  !                                                                            
  ! Copyright (C) 2010-2016 Samuel Ponce', Roxana Margine, Carla Verdi, Feliciano Giustino
  ! Copyright (C) 2007-2009 Jesse Noffsinger, Brad Malone, Feliciano Giustino  
  !                                                                            
  ! This file is distributed under the terms of the GNU General Public         
  ! License. See the file `LICENSE' in the root directory of the               
  ! present distribution, or http://www.gnu.org/copyleft.gpl.txt .             
  !                                                                            
  !-----------------------------------------------------------------------
  SUBROUTINE wfc_elec ( iq )
  !-----------------------------------------------------------------------
  !
  !  Compute the perturbed part of electron wavefunction (Mahan approximation, 
  !  generalized Frohlich vertex)
  !  CV
  !
  !  Use matrix elements, electronic eigenvalues and phonon frequencies
  !  from ep-wannier interpolation
  !
  !  This subroutine computes the contribution from phonon iq to all k-points
  !  The outer loop in ephwann_shuffle.f90 will loop over all iq points
  !  The contribution from each iq is summed at the end of this subroutine for iq=nqtotf
  !  to recover the per-ik electron wavefunction
  !
  !-----------------------------------------------------------------------
  USE kinds,         ONLY : DP
  USE io_global,     ONLY : stdout
  USE phcom,         ONLY : nmodes
  USE epwcom,        ONLY : nbndsub, lrepmatf, shortrange, &
                            fsthick, eptemp, ngaussw, degaussw, &
                            eps_acustic, efermi_read, fermi_energy, lscreen
  USE pwcom,         ONLY : ef !,nelec, isk
  USE elph2,         ONLY : etf, ibndmin, ibndmax, nkqf, xqf, &
                            nkf, epf17, wkf, nqtotf, wf, wqf, xkf, nkqtotf, &
                            efnew, eps_rpa, wfcel_all, xr, nir
  USE constants_epw, ONLY : ryd2mev, one, ryd2ev, two, zero, pi, ci, twopi, eps6
  USE mp,            ONLY : mp_barrier, mp_sum
  USE mp_global,     ONLY : inter_pool_comm
  !
  implicit none
  !
  INTEGER :: ik, ikk, ikq, ibnd, jbnd, imode, nrec, iq, fermicount, ir
  COMPLEX(kind=DP) :: cfac, weight
  REAL(kind=DP) :: g2, ekk, ekq, wq, ef0, wgkq, inv_eptemp0, w0g1, w0g2, &
                   rdotk, xxq(3), g2_tmp, inv_wq, inv_degaussw
  REAL(kind=DP), external :: wgauss, w0gauss
  REAL(kind=DP), PARAMETER :: eps2 = 0.01/ryd2mev
  !
  ! variables for collecting data from all pools in parallel case 
  !
  INTEGER :: nksqtotf, lower_bnd, upper_bnd
  REAL(kind=DP), ALLOCATABLE :: xkf_all(:,:), etf_all(:,:)
  !
  inv_eptemp0 = 1.0/eptemp
  inv_degaussw = 1.0/degaussw
  !
  IF ( iq .eq. 1 ) THEN
     !
     WRITE(6,'(/5x,a)') repeat('=',67)
     WRITE(6,'(5x,"Electron wavefunction from first order perturbation theory")')
     WRITE(6,'(5x,a/)') repeat('=',67)
     !
     IF ( fsthick .lt. 1.d3 ) &
        WRITE(stdout, '(/5x,a,f10.6,a)' ) 'Fermi Surface thickness = ', fsthick * ryd2ev, ' eV'
     WRITE(stdout, '(/5x,a,f10.6,a)' ) &
           'Golden Rule strictly enforced with T = ',eptemp * ryd2ev, ' eV'
     !
  ENDIF
  !
  ! Fermi level and corresponding DOS
  !
  IF ( efermi_read ) THEN
     ef0 = fermi_energy
  ELSE
     ef0 = efnew
  ENDIF
  !
  IF ( iq .eq. 1 ) THEN 
     WRITE (6, 100) degaussw * ryd2ev, ngaussw
     WRITE (6,'(a)') ' '
  ENDIF
  !
  xxq = xqf(:,iq)
  !
  ! The total number of k points
  !
  nksqtotf = nkqtotf/2 ! odd-even for k,k+q
  !
  ! find the bounds of k-dependent arrays in the parallel case in each pool
  CALL fkbounds( nksqtotf, lower_bnd, upper_bnd )
  !
  IF ( iq .eq. 1 ) THEN 
     !IF ( .not. ALLOCATED (wfcel_all) ) ALLOCATE( wfcel_all(ibndmax-ibndmin+1, nksqtotf, nir) )
     IF ( .not. ALLOCATED (wfcel_all) ) ALLOCATE( wfcel_all(nir) )
     wfcel_all(:) = (0.d0,0.d0)
  ENDIF
  !
  ! loop over all k points of the fine mesh
  !
  fermicount = 0 
  !DO ik = 1, nkf
  ik=1
     !
     ikk = 2 * ik - 1
     ikq = ikk + 1
     !
     ! here we must have ef, not ef0, to be consistent with ephwann_shuffle
     ! (but in this case they are the same)
     !
     IF ( ( minval ( abs(etf (:, ikk) - ef) ) .lt. fsthick ) .and. &
          ( minval ( abs(etf (:, ikq) - ef) ) .lt. fsthick ) ) THEN
        !
        fermicount = fermicount + 1
        !
        DO ir = 1, nir
           rdotk = twopi * dot_product( xxq (:), xr( :, ir) )
           cfac = exp( ci*rdotk )
           !
           DO imode = 1, nmodes
              !
              ! the phonon frequency and define the inverse for efficiency
              wq = wf (imode, iq)
              IF (lscreen) THEN
                 inv_wq = 1.0/( two * wq ) /(eps_rpa(imode))**two
              ELSE
                 inv_wq = 1.0/( two * wq )
              ENDIF
              !
              IF (wq .gt. eps_acustic) THEN
                g2_tmp = 1.0
              ELSE
                g2_tmp = 0.0
              ENDIF
              !
              !DO ibnd = 1, ibndmax-ibndmin+1
              ibnd=1
                 !
                 !  the energy of the electron at k (relative to Ef)
                 ekk = etf (ibndmin-1+ibnd, ikk) - ef0
                 !
                 !DO jbnd = 1, ibndmax-ibndmin+1
                 jbnd=1
                    !
                    !  the fermi occupation for k+q
                    ekq = etf (ibndmin-1+jbnd, ikq) - ef0
                    wgkq = wgauss( -ekq*inv_eptemp0, -99)  
                    !
                    ! here we take into account the zero-point sqrt(hbar/2M\omega)
                    ! with hbar = 1 and M already contained in the eigenmodes
                    ! g2 is Ry^2, wkf must already account for the spin factor
                    !
                    IF ( shortrange .AND. ( abs(xqf (1, iq))> eps2 .OR. abs(xqf (2, iq))> eps2 &
                       .OR. abs(xqf (3, iq))> eps2 )) THEN
                       g2 = (epf17 (jbnd, ibnd, imode, ik)**two)*inv_wq*g2_tmp
                    ELSE
                       g2 = (abs(epf17 (jbnd, ibnd, imode, ik))**two)*inv_wq*g2_tmp
                    ENDIF
                    !
                    weight = wqf(iq) * cfac * real (                                           &
                              (       one  ) / ( ekk - ( ekq + wq ) - ci * degaussw )**two )  
                    !weight = wqf(iq) * cfac * real (                                          &
                    !          ( (       wgkq ) / ( ekk - ( ekq - wq ) - ci * degaussw )**two  +  &
                    !          ( one - wgkq ) / ( ekk - ( ekq + wq ) - ci * degaussw )**two ) )
                    !
                    !wfcel_all(ibnd,ik+lower_bnd-1,ir) = wfcel_all(ibnd,ik+lower_bnd-1,ir) + g2 * weight
                    wfcel_all(ir) = wfcel_all(ir) + g2 * weight
                    !
                 !ENDDO !jbnd
                 !
              !ENDDO !ibnd
              !
           ENDDO !imode
           !
        ENDDO !ir
        !
     ENDIF ! endif  fsthick
        !
  !ENDDO ! end loop on k
  !
  ! The k points are distributed among pools: here we collect them
  !
  IF ( iq .eq. nqtotf ) THEN
     !
     ALLOCATE ( xkf_all      ( 3,       nkqtotf ), &
                etf_all      ( nbndsub, nkqtotf ) )
     xkf_all(:,:) = zero
     etf_all(:,:) = zero
     !
#if defined(__MPI)
     !
     ! note that poolgather2 works with the doubled grid (k and k+q)
     !
     CALL poolgather2 ( 3,       nkqtotf, nkqf, xkf,    xkf_all  )
     CALL poolgather2 ( nbndsub, nkqtotf, nkqf, etf,    etf_all  )
     !CALL mp_sum( wfcel_all, inter_pool_comm )
     CALL mp_sum(fermicount, inter_pool_comm)
     CALL mp_barrier(inter_pool_comm)
     !
#else
     !
     xkf_all = xkf
     etf_all = etf
     !
#endif
     !
     ! Output electron wfc here after looping over all q-points (with their contributions 
     ! summed in wfcel_all, etc.)
     !
     WRITE(6,'(5x,"WARNING: only the eigenstates within the Fermi window are meaningful")')
     !
     !DO ik = 1, nksqtotf
     ik=1
        !
        ikk = 2 * ik - 1
        ikq = ikk + 1
        !
        WRITE(stdout,'(/5x,"ik = ",i5," coord.: ", 3f12.7)') ik, xkf_all(:,ikk)
        WRITE(stdout,'(5x,a)') repeat('-',67)
        !
        !DO ibnd = 1, ibndmax-ibndmin+1
        ibnd=1
           !
           ! note that ekk does not depend on q 
           ekk = etf_all (ibndmin-1+ibnd, ikk) - ef0
           !
           WRITE(stdout,'(a,i4,a,f12.8)') "Band = ", ibndmin-1+ibnd, " , E = ", ryd2ev * ekk 
           !
           DO ir = 1, nir
              !WRITE(stdout,'(6f12.6)') wfcel_all(ibnd,ik,ir), abs(1+wfcel_all(ibnd,ik,ir))**two
              WRITE(stdout,'(3f12.6)') wfcel_all(ir), abs(1+wfcel_all(ir))**two
           ENDDO
           !
        !ENDDO
        WRITE(stdout,'(5x,a/)') repeat('-',67)
        !
     !ENDDO ! ik
     CALL mp_barrier(inter_pool_comm)
     !
     IF ( ALLOCATED(xkf_all) )      DEALLOCATE( xkf_all )
     IF ( ALLOCATED(etf_all) )      DEALLOCATE( etf_all )
     IF ( ALLOCATED(wfcel_all) )    DEALLOCATE( wfcel_all )
     !
  ENDIF 
  !
  100 FORMAT(5x,'Gaussian Broadening: ',f10.6,' eV, ngauss=',i4)
  !
  RETURN
  !
  END SUBROUTINE wfc_elec

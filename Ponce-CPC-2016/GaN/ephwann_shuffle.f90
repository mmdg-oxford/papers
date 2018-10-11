  !                                                                            
  ! Copyright (C) 2007-2009 Jesse Noffsinger, Brad Malone, Feliciano Giustino  
  !                                                                            
  ! This file is distributed under the terms of the GNU General Public         
  ! License. See the file `LICENSE' in the root directory of the               
  ! present distribution, or http://www.gnu.org/copyleft.gpl.txt .             
  !                                                                            
  !----------------------------------------------------------------------
  SUBROUTINE ephwann_shuffle( nqc, xqc )
  !---------------------------------------------------------------------
  !
  !  Wannier interpolation of electron-phonon vertex
  !
  !  Scalar implementation   Feb 2006
  !  Parallel version        May 2006
  !  Disentenglement         Oct 2006
  !  Compact formalism       Dec 2006
  !  Phonon irreducible zone Mar 2007
  !
  !  No ultrasoft now
  !  No spin polarization
  !
  !  RM - add noncolin case
  !-----------------------------------------------------------------------
  !
  !
#include "f_defs.h"
  USE kinds,         ONLY : DP
  USE pwcom,         ONLY : nbnd, nks, nkstot, isk, &
                            et, xk, at, bg, ef,  nelec
  USE start_k,       ONLY : nk1, nk2, nk3
  USE ions_base,     ONLY : amass, ityp
  USE phcom,         ONLY : lgamma, nq1, nq2, nq3, nmodes, w2
  USE epwcom,        ONLY : nbndsub, lrepmatf, fsthick, & 
                            lretf, epwread, epwwrite,       &
                            iunepmatwp, iunepmatwe, ngaussw, degaussw, &
                            nbndskip, parallel_k, epf_mem, etf_mem, &
                            elecselfen, phonselfen, nest_fn, fly, a2f, indabs, &
                            epexst, vme, eig_read, &
                            ephwrite, mp_mesh_k, & 
                            efermi_read, fermi_energy, specfun, band_plot
  USE noncollin_module, ONLY : noncolin
  USE constants_epw, ONLY : ryd2ev, ryd2mev, one, two
  USE control_flags, ONLY : iverbosity
  USE io_files,      ONLY : prefix, diropn
  USE io_global,     ONLY : stdout
  USE io_epw,        ONLY : lambda_phself,linewidth_phself,linewidth_elself, iunepmatf, &
                            iuetf
  USE elph2,         ONLY : nrr_k, nrr_q, cu, cuq, lwin, lwinq, irvec, ndegen_k, ndegen_q, &
                            wslen, chw, chw_ks, cvmew, cdmew, rdw, epmatwp, epmatq, &
                            wf, etf, etfq, etf_ks, xqf, xkf, wkf, epmatw17, &
                            dynq, nxqf, nksf, epf17, nksqf, et_ks, &
                            ibndmin, ibndmax, lambda_all, dmec, dmef, vmef, &
                            gamma_all, sigmai_all, nkstotf, lzstar, epsi, zstar, efnew
#ifdef __NAG
  USE f90_unix_io,   ONLY : flush
  USE,INTRINSIC :: f90_unix_file, ONLY:fstat, stat_t
#endif
#ifdef __PARA
  USE mp,            ONLY : mp_barrier, mp_bcast, mp_sum
  USE io_global,     ONLY : ionode_id
  USE mp_global,     ONLY : my_pool_id, nproc_pool, intra_image_comm, &
                            inter_pool_comm, me_pool, root_pool, intra_pool_comm, &
                            my_pool_id
  USE mp_world,      ONLY : mpime
#endif
  !
  implicit none
  !
#ifdef __NAG
  TYPE(stat_t) :: statb
#endif
#ifndef __NAG
  integer :: fstat,statb(13)
#endif
  !
  complex(kind=DP), ALLOCATABLE :: &
    epmatwe  (:,:,:,:),         &! e-p matrix  in wannier basis - electrons
    epmatwef (:,:,:,:)           ! e-p matrix  in el wannier - fine Bloch phonon grid
  complex(kind=DP), ALLOCATABLE :: &
    epmatf( :, :, :),           &! e-p matrix  in smooth Bloch basis, fine mesh
    cufkk ( :, :),              &! Rotation matrix, fine mesh, points k
    cufkq ( :, :),              &! the same, for points k+q
    uf    ( :, :),              &! Rotation matrix for phonons
    bmatf ( :, :)                ! overlap U_k+q U_k^\dagger in smooth Bloch basis, fine mesh
  integer :: &
    nqc                          ! number of qpoints in the coarse grid
  real(kind=DP) :: &
    xqc (3, nqc)                 ! qpoint list, coarse mesh
  !
  integer :: iq, ik, ikk, ikq, ibnd, jbnd, pbnd, imode, ir, na, nu, mu, n, &
    fermicount, nrec, indnew, indold, lrepmatw, ios, i, j
  LOGICAL :: already_skipped, exst
  character (len=256) :: filint
  character (len=30)  :: myfmt
  real(kind=DP) :: xxq(3), xxk(3), xkk(3), xkq(3), size_m, &
    wq, w_1, w_2, gamma, g2, epc(nbndsub, nbndsub, nmodes), epc_sym(nbndsub,nbndsub, nmodes)
  real(kind=DP), external :: efermig
  real(kind=DP), parameter :: eps = 0.01/ryd2mev
  complex(kind=DP) :: gfr(nbndsub,nbndsub,nmodes),aaa(nmodes)
  ! 
  IF (nbndsub.ne.nbnd) &
       WRITE(stdout, '(/,14x,a,i4)' ) 'band disentanglement is used:  nbndsub = ', nbndsub
  !
  ALLOCATE ( cu ( nbnd, nbndsub, nks), & 
             cuq ( nbnd, nbndsub, nks), & 
             lwin ( nbnd, nks ), &
             lwinq ( nbnd, nks ), &
             irvec (3, 20*nk1*nk2*nk3), &
             ndegen_k (20*nk1*nk2*nk3), &
             ndegen_q (20*nq1*nq2*nq3), &
             wslen(20*nk1*nk2*nk3)      )
  !
  CALL start_clock ( 'ephwann' )
 !
  IF (parallel_k) THEN
     CALL loadqmesh_serial
     CALL loadkmesh_para
  ELSE
     CALL errore('ephwann_shuffle', "parallel q not (yet) implemented",1)
  ENDIF
  !
  !
  ! determine Wigner-Seitz points
  !
  CALL wigner_seitz2 &
       ( nk1, nk2, nk3, nq1, nq2, nq3, nrr_k, nrr_q, irvec, wslen, ndegen_k, ndegen_q )
  !
  !
  ! allocate dipole matrix elements after getting grid size
  !
  ALLOCATE ( dmef(3, nbndsub, nbndsub, 2 * nksqf) )
  IF (vme) ALLOCATE ( vmef(3, nbndsub, nbndsub, 2 * nksqf) )
  !
  ! open the .epmatwe and .epmatwp file[s] with the proper record length
  !
  iunepmatwp = 111
  iunepmatwe = 112
  lrepmatw   = 2 * nbndsub * nbndsub * nrr_k * nmodes 
  !
  filint    = trim(prefix)//'.epmatwe'
  IF (.not.epwread) CALL diropn (iunepmatwe, 'epmatwe', lrepmatw, exst)
  !
  filint    = trim(prefix)//'.epmatwp'
  CALL diropn (iunepmatwp, 'epmatwp', lrepmatw, exst)
  !
  ! at this point, we will interpolate the Wannier rep to the Bloch rep 
  !
  IF ( epwread ) THEN
     !
     !  read all quantities in Wannier representation from file
     !  in parallel case all pools read the same file
     !
     CALL epw_read
     !
  ELSE !if not epwread (i.e. need to calculate fmt file)
     !
     xxq = 0.d0 
     CALL loadumat &
          ( nbnd, nbndsub, nks, nkstot, xxq, cu, cuq, lwin, lwinq )  
     !
     ! ------------------------------------------------------
     !   Bloch to Wannier transform
     ! ------------------------------------------------------
     !
     ALLOCATE ( epmatwe ( nbndsub, nbndsub, nrr_k, nmodes), &
          epmatwp ( nbndsub, nbndsub, nrr_k, nmodes), &
          chw     ( nbndsub, nbndsub, nrr_k ),        &
          chw_ks  ( nbndsub, nbndsub, nrr_k ),        &
          cdmew   ( 3, nbndsub, nbndsub, nrr_k ),     &
          rdw     ( nmodes,  nmodes,  nrr_q ) )
     IF (vme) ALLOCATE(cvmew   ( 3, nbndsub, nbndsub, nrr_k ) )
     !
     ! Hamiltonian
     !
     CALL hambloch2wan &
          ( nbnd, nbndsub, nks, nkstot, lgamma, et, xk, cu, lwin, nrr_k, irvec, wslen, chw )
     !
     ! Kohn-Sham eigenvalues
     !
     IF (eig_read) THEN
        WRITE (6,'(5x,a)') "Interpolating MB and KS eigenvalues"
        CALL hambloch2wan &
             ( nbnd, nbndsub, nks, nkstot, lgamma, et_ks, xk, cu, lwin, nrr_k, irvec, wslen, chw_ks )
     ENDIF
     !
     ! Dipole
     !
    ! CALL dmebloch2wan &
    !      ( nbnd, nbndsub, nks, nkstot, nkstot, lgamma, dmec, xk, cu, nrr_k, irvec, wslen )
     CALL dmebloch2wan &
          ( nbnd, nbndsub, nks, nkstot, dmec, xk, cu, nrr_k, irvec, wslen )
     !
     ! Dynamical Matrix 
     !
     CALL dynbloch2wan &
          ( nmodes, nqc, xqc, dynq, nrr_q, irvec, wslen )
     !
     ! Transform of position matrix elements
     ! PRB 74 195118  (2006)
     IF (vme) CALL vmebloch2wan &
         ( nbnd, nbndsub, nks, nks, nkstot, lgamma, xk, cu, nrr_k, irvec, wslen )
     !
     ! Electron-Phonon vertex (Bloch el and Bloch ph -> Wannier el and Bloch ph)
     !
     DO iq = 1, nqc
        !
        xxq = xqc (:, iq)
        !
        ! we need the cu again for the k+q points, we generate the map here
        !
        CALL loadumat ( nbnd, nbndsub, nks, nkstot, xxq, cu, cuq, lwin, lwinq )
        !
        DO imode = 1, nmodes
           !
           CALL ephbloch2wane &
                ( nbnd, nbndsub, nks, nkstot, lgamma, xk, cu, cuq, lwin, lwinq, &
                epmatq (:,:,:,imode,iq), nrr_k, irvec, wslen, epmatwe(:,:,:,imode) )
           !
        ENDDO
        !
        ! direct write of epmatwe for this iq 
        IF (.not.epexst) CALL rwepmatw ( epmatwe, nbndsub, nrr_k, nmodes, iq, iunepmatwe, +1)
        !
     ENDDO
     !
     ! Electron-Phonon vertex (Wannier el and Bloch ph -> Wannier el and Wannier ph)
     !
     CALL ephbloch2wanp &
          ( nbndsub, nmodes, xqc, nqc, irvec, wslen, nrr_k, nrr_q, epmatwe )
     !
     IF ( epwwrite ) THEN
        CALL epw_write 
        CALL epw_read 
     ENDIF
     !
  ENDIF
  !
  !
  IF ( ALLOCATED (epmatwe) ) DEALLOCATE (epmatwe)
  IF ( ALLOCATED (epmatq) )  DEALLOCATE (epmatq)
  IF ( ALLOCATED (cu) )      DEALLOCATE (cu)
  IF ( ALLOCATED (cuq) )     DEALLOCATE (cuq)
  IF ( ALLOCATED (lwin) )    DEALLOCATE (lwin)
  IF ( ALLOCATED (lwinq) )   DEALLOCATE (lwinq)
  !
  ! at this point, we will interpolate the Wannier rep to the Bloch rep 
  ! for electrons, phonons and the ep-matrix
  !
  !  need to add some sort of parallelization (on g-vectors?)  what
  !  else can be done when we don't ever see the wfcs??
  !
  ALLOCATE ( epmatwef( nbndsub, nbndsub, nrr_k, nmodes),             &
       wf ( nmodes,  nxqf ), etf ( nbndsub, nksf),                   &
       etf_ks ( nbndsub, nksf),                   &
       epmatf( nbndsub, nbndsub, nmodes), cufkk ( nbndsub, nbndsub), &
       cufkq ( nbndsub, nbndsub), uf ( nmodes, nmodes),              &
       bmatf( nbndsub, nbndsub) )
  !
  IF (fly) THEN
     ALLOCATE ( etfq(nbndsub, nksf,    1) )
  ELSE
     ALLOCATE ( etfq(nbndsub, nksf, nxqf) )
  ENDIF
  !
  ! ------------------------------------------------------
  ! hamiltonian : Wannier -> Bloch (preliminary)
  ! ------------------------------------------------------
  !
  ! we here perform a preliminary interpolation of the hamiltonian
  ! in order to determine the fermi window ibndmin:ibndmax for later use.
  ! We will interpolate again afterwards, for each k and k+q separately
  !
  xxq = 0.d0
  !
  ! nksf is the number of kpoints in the pool
  ! parallel_k case = nkstotf/npool
  ! parallel_q case = nkstotf
  DO ik = 1, nksf
     !
     xxk = xkf (:, ik)
     !
     IF ( 2*(ik/2).eq.ik ) THEN
        !
        !  this is a k+q point : redefine as xkf (:, ik-1) + xxq
        !
        CALL cryst_to_cart ( 1, xxq, at,-1 )
        xxk = xkf (:, ik-1) + xxq
        CALL cryst_to_cart ( 1, xxq, bg, 1 )
        !
     ENDIF
     !
     CALL hamwan2bloch &
          ( nbndsub, nrr_k, irvec, ndegen_k, xxk, cufkk, etf (:, ik), chw)
     !
     !
  ENDDO
  !
  ! 27/06/2012 RM
  ! in the case when a random or uniform fine k-mesh is used
  ! calculate the Fermi level corresponding to the fine k-mesh 
  ! this Fermi level is then used as a reference in fermiwindow 
  ! 06/05/2014 CV
  ! calculate the Fermi level corresponding to the fine k-mesh
  ! or read it from input (Fermi level from the coarse grid 
  ! may be wrong or inaccurate)
  !
  WRITE(6,'(/5x,a,f10.6,a)') 'Fermi energy coarse grid = ', ef * ryd2ev, ' eV'
  !
  IF( efermi_read ) THEN
     !
     ef = fermi_energy
     WRITE(6,'(/5x,a)') repeat('=',67)
     WRITE(6, '(/5x,a,f10.6,a)') &
         'Fermi energy is read from the input file: Ef = ', ef * ryd2ev, ' eV'
     WRITE(6,'(/5x,a)') repeat('=',67)
     !
  ELSEIF( band_plot ) THEN 
     !
     WRITE(6,'(/5x,a)') repeat('=',67)
     WRITE(stdout, '(/5x,"Fermi energy corresponds to the coarse k-mesh")')
     WRITE(6,'(/5x,a)') repeat('=',67) 
     !
  ELSE 
     ! here we take into account that we may skip bands when we wannierize
     ! (spin-unpolarized)
     ! RM - add the noncolin case
     already_skipped = .false.
     IF ( nbndskip .gt. 0 ) THEN
        IF ( .not. already_skipped ) THEN
           IF ( noncolin ) THEN 
              nelec = nelec - one * nbndskip
           ELSE
              nelec = nelec - two * nbndskip
           ENDIF
           already_skipped = .true.
           WRITE(6,'(/5x,"Skipping the first ",i4," bands:")') nbndskip
           WRITE(6,'(/5x,"The Fermi level will be determined with ",f9.5," electrons")') nelec
        ENDIF
     ENDIF
     !
     ! Fermi energy
     !  
     ! etf(:,ikk) = etfq(:,ikk,1), etf(:,ikq) = etfq(:,ikq,nxqf) - last q point
     ! since wkf(:,ikq) = 0 these bands do not bring any contribution to Fermi level
     !  
     efnew = efermig(etf, nbndsub, nksf, nelec, wkf, degaussw, ngaussw, 0, isk)
     !
     WRITE(6, '(/5x,a,f10.6,a)') &
         'Fermi energy is calculated from the fine k-mesh: Ef = ', efnew * ryd2ev, ' eV'
     !
     ! if 'fine' Fermi level differs by more than 250 meV, there is probably something wrong
     ! with the wannier functions, or 'coarse' Fermi level is inaccurate
     IF (abs(efnew - ef) * ryd2eV .gt. 0.250d0 .and. (.not.eig_read) ) &
        WRITE(6,'(/5x,a)') 'Warning: check if difference with Fermi level fine grid makes sense'
     WRITE(6,'(/5x,a)') repeat('=',67)
     !
     ef=efnew
     !
  ENDIF
  !
  ! identify the bands within fsthick from the Fermi level
  ! (in shuffle mode this actually does not depend on q)
  !
  !
  CALL fermiwindow
  !
  ! get the size of the matrix elements stored in each pool
  ! for informational purposes.  Not necessary
  !
  CALL mem_size(ibndmin, ibndmax, nmodes, nksqf, nxqf, fly) 
  !
  IF (etf_mem) THEN
     ! Fine mesh set of g-matrices.  It is large for memory storage
     IF (fly) THEN
        ALLOCATE ( epf17 (nksqf, 1,    ibndmax-ibndmin+1, ibndmax-ibndmin+1, nmodes) )
     ELSE
        ALLOCATE ( epf17 (nksqf, nxqf, ibndmax-ibndmin+1, ibndmax-ibndmin+1, nmodes) )
     ENDIF
     !
  ELSE
     !
     !  open epf and etf files with the correct record length
     !
     lrepmatf  = 2 * (ibndmax-ibndmin+1) * (ibndmax-ibndmin+1)
     CALL diropn (iunepmatf, 'epf', lrepmatf, exst)
     !
     lretf     = (ibndmax-ibndmin+1) 
     CALL diropn (iuetf, 'etf', lretf, exst)
     !
  ENDIF
  !
  !
  IF (epf_mem) THEN
     !
     ALLOCATE ( epmatw17 ( nbndsub, nbndsub, nrr_k, nrr_q, nmodes) )
     !  
     !  direct read of epmatw17 - wannier matrices on disk from epwwrite
#ifdef __NAG
     CALL fstat( iunepmatwp, statb, errno=ios)
     size_m = dble(statb%st_size)/(1024.d0**2)
#endif
#ifndef __NAG
     ios = fstat( iunepmatwp, statb)
     size_m = dble(statb(8))/(1024.d0**2)
#endif
     WRITE (6,'(5x,a,f10.2,a)') "Loading Wannier rep into memory: ", size_m, " MB"
     DO ir = 1, nrr_q
        CALL rwepmatw ( epmatw17(:,:,:,ir,:), nbndsub, nrr_k, nmodes, ir, iunepmatwp, -1)
     ENDDO
     !
  ENDIF
  !
  !  xqf must be in crystal coordinates
  !
  ! this loops over the fine mesh of q points.
  ! if parallel_k then this is the entire q-list (nxqftot)
  ! if parallel_q then this is nxqftot/npool
  !
  DO iq = 1, nxqf
     !   
     CALL start_clock ( 'ep-interp' )
     !
     IF (.not.fly) THEN
        IF (iverbosity .ge. 1) THEN
           WRITE(6,'(/5x,"Interpolating ",i6," out of ",i6)') iq, nxqf
           CALL flush(6)
        ELSE
           !
           IF (iq.eq.1) THEN
              WRITE(6,'(/5x,"Interpolation progress: ")',advance='no')
              indold = 0
           ENDIF
           indnew = nint(dble(iq)/dble(nxqf)*40)
           IF (indnew.ne.indold) WRITE(6,'(a)',advance='no') '#'
           indold = indnew
       ENDIF
     ENDIF
     !
     xxq = xqf (:, iq)
     !
     ! ------------------------------------------------------
     ! dynamical matrix : Wannier -> Bloch
     ! ------------------------------------------------------
     !
     CALL dynwan2bloch &
          ( nmodes, nrr_q, irvec, ndegen_q, xxq, uf, w2 )
     !
     ! ...then take into account the mass factors and square-root the frequencies...
     !
     DO nu = 1, nmodes
        !
        ! wf are the interpolated eigenfrequencies
        ! (omega on fine grid)
        !
        IF ( w2 (nu) .gt. 0.d0 ) THEN
           wf(nu,iq) =  sqrt(abs( w2 (nu) ))
        ELSE
           wf(nu,iq) = -sqrt(abs( w2 (nu) ))
        ENDIF
        !
        DO mu = 1, nmodes
           na = (mu - 1) / 3 + 1
           uf (mu, nu) = uf (mu, nu) / sqrt(amass(ityp(na)))
        ENDDO
     ENDDO
     !
     ! --------------------------------------------------------------
     ! epmat : Wannier el and Wannier ph -> Wannier el and Bloch ph
     ! --------------------------------------------------------------
     !
     CALL ephwan2blochp &
          ( nmodes, xxq, irvec, ndegen_q, nrr_q, uf, epmatwef, nbndsub, nrr_k )
     !
     !
     !  number of k points with a band on the Fermi surface
     fermicount = 0
     !
     ! this is a loop over k blocks in the pool
     ! (size of the local k-set)
     epc=0.d0
     epc_sym=0.d0
     !
     DO ik = 1, nksqf
        !
        ! xkf is assumed to be in crys coord
        !
        ikk = 2 * ik - 1
        ikq = ikk + 1
        !
        xkk = xkf(:, ikk)
        xkq = xkk + xxq
        !
        ! ------------------------------------------------------        
        ! hamiltonian : Wannier -> Bloch 
        ! ------------------------------------------------------
        !
        ! Kohn-Sham first, then get the rotation matricies for following interp.
        IF (eig_read) THEN
           CALL hamwan2bloch &
             ( nbndsub, nrr_k, irvec, ndegen_k, xkk, cufkk, etf_ks (:, ikk), chw_ks)
           CALL hamwan2bloch &
             ( nbndsub, nrr_k, irvec, ndegen_k, xkq, cufkq, etf_ks (:, ikq), chw_ks)
        ENDIF
        !
        CALL hamwan2bloch &
             ( nbndsub, nrr_k, irvec, ndegen_k, xkk, cufkk, etf (:, ikk), chw)
        CALL hamwan2bloch &
             ( nbndsub, nrr_k, irvec, ndegen_k, xkq, cufkq, etf (:, ikq), chw)
        !
        ! ------------------------------------------------------        
        !  dipole: Wannier -> Bloch
        ! ------------------------------------------------------        
        !
        CALL dmewan2bloch &
             ( nbndsub, nrr_k, irvec, ndegen_k, xkk, cufkk, dmef (:,:,:, ikk), etf(:,ikk), etf_ks(:,ikk))
        CALL dmewan2bloch &
             ( nbndsub, nrr_k, irvec, ndegen_k, xkq, cufkq, dmef (:,:,:, ikq), etf(:,ikq), etf_ks(:,ikq))
        !
        ! ------------------------------------------------------        
        !  velocity: Wannier -> Bloch
        ! ------------------------------------------------------        
        !
        IF (vme) THEN
           IF (eig_read) THEN
              CALL vmewan2bloch &
                   ( nbndsub, nrr_k, irvec, ndegen_k, xkk, cufkk, vmef (:,:,:, ikk), etf(:,ikk), etf_ks(:,ikk), chw_ks)
              CALL vmewan2bloch &
                   ( nbndsub, nrr_k, irvec, ndegen_k, xkq, cufkq, vmef (:,:,:, ikq), etf(:,ikq), etf_ks(:,ikq), chw_ks)
           ELSE
              CALL vmewan2bloch &
                   ( nbndsub, nrr_k, irvec, ndegen_k, xkk, cufkk, vmef (:,:,:, ikk), etf(:,ikk), etf_ks(:,ikk), chw)
              CALL vmewan2bloch &
                   ( nbndsub, nrr_k, irvec, ndegen_k, xkq, cufkq, vmef (:,:,:, ikq), etf(:,ikq), etf_ks(:,ikq), chw)
           ENDIF
        ENDIF
        !
        !
        IF (etf_mem) THEN
           ! store in mem, otherwise the parall in q is going to read a mess on file
           ! this is an array size (ibndmax-ibndmin+1)*(k blocks in the pool)*(total number of qs on fine mesh)
           ! parallel in K!
           IF (fly) THEN
              etfq(:,ikk, 1) = etf (:, ikk)
              etfq(:,ikq, 1) = etf (:, ikq)
           ELSE
              etfq(:,ikk,iq) = etf (:, ikk)
              etfq(:,ikq,iq) = etf (:, ikq)
           ENDIF
           !
        ELSE
           nrec = (iq-1) * nksf + ikk
           IF (fly) nrec  = ikk
           CALL davcio ( etf (ibndmin:ibndmax, ikk), ibndmax-ibndmin+1, iuetf, nrec, + 1)
           nrec = (iq-1) * nksf + ikq
           IF (fly) nrec  = ikq
           CALL davcio ( etf (ibndmin:ibndmax, ikq), ibndmax-ibndmin+1, iuetf, nrec, + 1)
           !
        ENDIF
        !
        ! interpolate ONLY when (k,k+q) both have at least one band 
        ! within a Fermi shell of size fsthick 
        !
        IF ( (( minval ( abs(etf (:, ikk) - ef) ) .lt. fsthick ) .and. &
             ( minval ( abs(etf (:, ikq) - ef) ) .lt. fsthick )) .or. indabs ) THEN
           !
           !  fermicount = fermicount + 1
           !
           ! --------------------------------------------------------------
           ! epmat : Wannier el and Bloch ph -> Bloch el and Bloch ph
           ! --------------------------------------------------------------
           !
           !
           CALL ephwan2bloch &
                ( nbndsub, nrr_k, irvec, ndegen_k, epmatwef, xkk, cufkk, cufkq, epmatf, nmodes )
           !
           ! 
           ! write epmatf to file / store in memory
           !
           !
           DO imode = 1, nmodes
              !
              IF (etf_mem) THEN
                 !
                 DO jbnd = ibndmin, ibndmax
                    DO ibnd = ibndmin, ibndmax
                       !
                       IF (fly) THEN
                          epf17(ik, 1,jbnd-ibndmin+1,ibnd-ibndmin+1,imode) = epmatf(jbnd,ibnd,imode)
                       ELSE
                          epf17(ik,iq,jbnd-ibndmin+1,ibnd-ibndmin+1,imode) = epmatf(jbnd,ibnd,imode)
                       ENDIF
                       !
                    ENDDO
                 ENDDO
                 !
              ELSE
                 !
                 nrec = (iq-1) * nmodes * nksqf + (imode-1) * nksqf + ik
                 IF (fly)  nrec = (imode-1) * nksqf + ik
                 CALL dasmio ( epmatf(ibndmin:ibndmax,ibndmin:ibndmax,imode), &
                      ibndmax-ibndmin+1, lrepmatf, iunepmatf, nrec, +1)
                 !
              ENDIF
              !
           ENDDO
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
           ! calculate the vertex |g| [Ry] for k=0 (needs to be in the first pool)
           !
           !goto 125
           IF ( abs(xkk(1)).lt.eps .and. abs(xkk(2)).lt.eps .and. abs(xkk(3)).lt.eps ) THEN
           !IF (ik.eq.2) THEN
           WRITE(6,'(a,3f10.6)') "k coord: ", xkk(1), xkk(2), xkk(3)
           !
           DO imode = 1, nmodes
              wq = wf (imode, iq)
              DO ibnd = ibndmin, ibndmax
                 DO jbnd = ibndmin, ibndmax
                    gamma = abs(epmatf (jbnd, ibnd, imode))**two
                    if (wq.gt.0.d0) then
                        gamma = gamma / (two * wq)
                    else
                        gamma = 0.d0
                    endif
                    if (gamma.lt.0.d0) gamma = 0.d0
                    gamma = sqrt(gamma)
                    ! gamma = |g| [Ry]
                    epc(ibnd,jbnd,imode) = gamma
                 ENDDO ! jbnd
              ENDDO   ! ibnd        
           ENDDO ! loop on q-modes
           !
           !  HERE WE "SYMMETRIZE": actually we simply take the averages over
           !  degenerate states, it is only a convention because g is gauge-dependent!
           !
           ! first the phonons
           do ibnd = ibndmin, ibndmax
           do jbnd = ibndmin, ibndmax
             do nu = 1, nmodes
               w_1 = wf(nu,iq)
               g2 = 0.d0
               n  = 0
               do mu = 1, nmodes
                 w_2 = wf(mu,iq)
                 if ( abs(w_2-w_1).lt.eps ) then
                    n = n + 1
                    g2 = g2 + epc(ibnd,jbnd,mu)*epc(ibnd,jbnd,mu)
                 endif
               enddo 
               g2 = g2 / float(n)
               epc_sym (ibnd, jbnd, nu) = sqrt (g2)
             enddo
           enddo
           enddo
           epc = epc_sym
           !
           ! then the k electrons
           do nu   = 1, nmodes
           do jbnd = ibndmin, ibndmax
             do ibnd = ibndmin, ibndmax
               w_1 = etf (ibnd, ikk)
               g2 = 0.d0
               n  = 0
               do pbnd = ibndmin, ibndmax
                 w_2 = etf (pbnd, ikk)
                 if ( abs(w_2-w_1).lt.eps ) then
                    n = n + 1
                    g2 = g2 + epc(pbnd,jbnd,nu)*epc(pbnd,jbnd,nu)
                 endif
               enddo 
               g2 = g2 / float(n)
               epc_sym (ibnd, jbnd, nu) = sqrt (g2)
             enddo
           enddo
           enddo
           epc = epc_sym
           !
           ! and finally the k+q electrons
           do nu   = 1, nmodes
           do ibnd = ibndmin, ibndmax
             do jbnd = ibndmin, ibndmax
               w_1 = etf (jbnd, ikq)
               g2 = 0.d0
               n  = 0
               do pbnd = ibndmin, ibndmax
                 w_2 = etf(pbnd, ikq)
                 if ( abs(w_2-w_1).lt.eps ) then
                    n = n + 1
                    g2 = g2 + epc(ibnd,pbnd,nu)*epc(ibnd,pbnd,nu)
                 endif
               enddo 
               g2 = g2 / float(n)
               epc_sym (ibnd, jbnd, nu) = sqrt (g2)
             enddo
           enddo
           enddo
           epc = epc_sym
           !
           do ibnd = ibndmin, ibndmax
           do jbnd = ibndmin, ibndmax
              do imode = 1, nmodes
                 write(6,'(3i5,4f15.6)') ibnd, jbnd, imode, &
                   ryd2ev * etf(ibnd,ikk), ryd2ev * etf (jbnd, ikq), &
                   ryd2mev * wf(imode,iq), ryd2mev * epc(ibnd,jbnd,imode)
              enddo
           enddo
           enddo
           !
           !!!!!
           !
           ENDIF ! ikk=1
           !125 continue
           !
        ELSE
           IF ( abs(xkk(1)).lt.eps .and. abs(xkk(2)).lt.eps .and. abs(xkk(3)).lt.eps ) &
           WRITE(6,'(a)') 'k=0 not in fsthick'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        !
        ENDIF ! fsthick
        !
     ENDDO  ! end loop over k points
     !
     IF (phonselfen  .and. fly) CALL selfen_phon_fly( iq )
     IF (elecselfen  .and. fly) CALL selfen_elec_fly( iq )
     IF (nest_fn     .and. fly) CALL nesting_fn_fly( iq )
     IF (specfun     .and. fly) CALL spectral_func_fly( iq )
!     IF (indabs      .and. fly) CALL indabs_fly (iq)
!     IF (twophoton   .and. fly) CALL twophoton_fly (iq)
     IF (ephwrite .and. fly) THEN
        IF ( iq .eq. 1 ) THEN 
           IF ( mp_mesh_k ) THEN
              CALL kmesh_fine_mp
              CALL kqmap_fine_mp
           ELSE
              CALL kmesh_fine
              CALL kqmap_fine
           ENDIF
        ENDIF
        CALL write_ephmat_fly( iq ) 
        CALL count_kpoints(iq)
     ENDIF
     !
     CALL stop_clock ( 'ep-interp' )
     !
  ENDDO  ! end loop over q points
!SP: Added lambda and phonon lifetime writing to file.
#ifdef __PARA
  CALL mp_barrier(inter_pool_comm)
  IF (mpime.eq.ionode_id) THEN
#endif
    IF (phonselfen .and. fly) THEN
      OPEN(unit=lambda_phself,file='lambda.phself')
      WRITE(lambda_phself, '(/2x,a/)') '#Lambda phonon self-energy'
      WRITE(lambda_phself, *) '#Modes     ',(imode, imode=1,nmodes)
      DO iq = 1, nxqf
          !
        myfmt = "(*(3x,E15.5))"
        WRITE(lambda_phself,'(i9,4x)',advance='no') iq
        WRITE(lambda_phself, fmt=myfmt) (REAL(lambda_all(imode,iq,1)),imode=1,nmodes)
          !
      ENDDO
      CLOSE(lambda_phself)
      OPEN(unit=linewidth_phself,file='linewidth.phself')
      WRITE(linewidth_phself, '(/2x,a/)') '#Phonon lifetime (meV) '
      WRITE(linewidth_phself,'(2x,a)',advance='no') '#Q-point     '
      Do imode=1, nmodes
        WRITE(linewidth_phself, '(a)',advance='no') '      Mode'
        WRITE(linewidth_phself, '(i3)',advance='no') imode
      enddo
      DO iq = 1, nxqf
        !
        myfmt = "(*(3x,E15.5))"
        WRITE(linewidth_phself,'(i9,4x)',advance='no') iq
        WRITE(linewidth_phself, fmt=myfmt) (ryd2mev*REAL(gamma_all(imode,iq,1)), imode=1,nmodes)
        !
      ENDDO
      CLOSE(linewidth_phself)
    ENDIF
    IF (elecselfen .and. fly) THEN
      OPEN(unit=linewidth_elself,file='linewidth.elself')
      WRITE(linewidth_elself, '(/2x,a/)') '#Electron lifetime (meV)'
      WRITE(linewidth_elself, *) '#Band     ',(ibnd,ibnd=ibndmin,ibndmax)
      DO ik = 1, nkstotf/2
          !
        myfmt = "(*(3x,E15.5))" 
        WRITE(linewidth_elself,'(i9,4x)',advance='no') ik
        WRITE(linewidth_elself, fmt=myfmt) (ryd2mev*sigmai_all(ibnd,ik),ibnd=1,ibndmax-ibndmin+1)
          !
      ENDDO
      CLOSE(linewidth_elself)
    ENDIF
#ifdef __PARA
  ENDIF
#endif
  IF (a2f .and. fly) CALL eliashberg_a2f
  ! 
  IF ( ALLOCATED(lambda_all) )   DEALLOCATE( lambda_all )
  IF ( ALLOCATED(gamma_all) )   DEALLOCATE( gamma_all )
  IF ( ALLOCATED(sigmai_all) )   DEALLOCATE( sigmai_all )
  !
  !
  CALL stop_clock ( 'ephwann' )
  !
  END SUBROUTINE ephwann_shuffle
  !
!-------------------------------------------
SUBROUTINE epw_write
!-------------------------------------------
  !
  USE epwcom,    ONLY : nbndsub, vme, eig_read
  USE pwcom,     ONLY : ef
  USE elph2,     ONLY : nrr_k, nrr_q, chw, rdw, cdmew, cvmew, chw_ks, &
                        lzstar, zstar, epsi
  USE phcom,     ONLY : nmodes  
  USE io_epw,    ONLY : epwdata, iundmedata, iunvmedata, iunksdata
#ifdef __PARA
  USE mp,        ONLY : mp_barrier
  USE mp_global, ONLY : my_pool_id,inter_pool_comm
  USE mp_world,  ONLY : mpime
  USE io_global, ONLY : ionode_id
#endif
  !
  implicit none
  INTEGER           :: ibnd, jbnd, jmode, imode, irk, irq, ipol
  !
  WRITE(6,'(/5x,"Writing Hamiltonian, Dynamical matrix and EP vertex in Wann rep to file"/)')
  !
#ifdef __PARA
     IF (mpime.eq.ionode_id) THEN
#endif     
       !
       OPEN(unit=epwdata,file='epwdata.fmt')
       OPEN(unit=iundmedata,file='dmedata.fmt')
       IF (vme) OPEN(unit=iunvmedata,file='vmedata.fmt')
       IF (eig_read) OPEN(unit=iunksdata,file='ksdata.fmt')
       WRITE (epwdata,*) ef
       WRITE (epwdata,*) nbndsub, nrr_k, nmodes, nrr_q
       WRITE (epwdata,*) lzstar
       WRITE (epwdata,*) zstar, epsi
       !
       DO ibnd = 1, nbndsub
          DO jbnd = 1, nbndsub
             DO irk = 1, nrr_k
                WRITE (epwdata,*) chw(ibnd,jbnd,irk)
                IF (eig_read) WRITE (iunksdata,*) chw_ks(ibnd,jbnd,irk)
                DO ipol = 1,3
                   WRITE (iundmedata,*) cdmew(ipol, ibnd,jbnd,irk)
                   IF (vme) WRITE (iunvmedata,*) cvmew(ipol, ibnd,jbnd,irk)
                ENDDO
             ENDDO
          ENDDO
       ENDDO
       !
       DO imode = 1, nmodes
          DO jmode = 1, nmodes
             DO irq = 1, nrr_q
                WRITE (epwdata,*) rdw(imode,jmode,irq) 
             ENDDO
          ENDDO
       ENDDO
       !
       ! CV: we don't need this (might change)
       !DO irq = 1, nrr_q
          !
          ! direct read epmatwp for this irq 
       !   CALL rwepmatwp ( nbndsub, nrr_k, nmodes, irq, iunepmatwp, -1)
          !
       !   DO ibnd = 1, nbndsub
       !      DO jbnd = 1, nbndsub
       !         DO irk = 1, nrr_k
       !            DO imode = 1, nmodes
       !               WRITE (epwdata,*) epmatwp(ibnd,jbnd,irk,imode) 
       !            ENDDO
       !         ENDDO
       !      ENDDO
       !   ENDDO
          !
       !ENDDO
       !
       CLOSE(epwdata)
       CLOSE(iundmedata)
       IF (vme) CLOSE(iunvmedata)
       IF (eig_read) CLOSE(iunksdata)
       !
#ifdef __PARA
    ENDIF
    CALL mp_barrier(inter_pool_comm)
#endif     
     !
!---------------------------------
END SUBROUTINE epw_write
!---------------------------------
!---------------------------------
SUBROUTINE epw_read()
!---------------------------------
  USE epwcom,    ONLY : nbndsub, vme, eig_read
  USE pwcom,     ONLY : ef
  USE elph2,     ONLY : nrr_k, nrr_q, chw, rdw, epmatwp, &
                        cdmew, cvmew, chw_ks, lzstar, zstar, epsi
  USE phcom,     ONLY : nmodes  
  USE io_global, ONLY : stdout
  USE io_epw,    ONLY : epwdata, iundmedata, iunvmedata, iunksdata
#ifdef __NAG
  USE f90_unix_io,ONLY : flush
#endif
#ifdef __PARA
  USE io_global, ONLY : ionode_id
  USE mp,        ONLY : mp_barrier, mp_bcast
  USE mp_global, ONLY : my_pool_id, &
                        intra_pool_comm, inter_pool_comm, root_pool
  USE mp_world,  ONLY : mpime
#endif
  !
  implicit none
  !
  !
  INTEGER           :: ibnd, jbnd, jmode, imode, irk, irq, &
                       ipol, ios
     !
     WRITE(stdout,'(/5x,"Reading Hamiltonian, Dynamical matrix and EP vertex in Wann rep from file"/)')
     call flush(6)
#ifdef __PARA
    IF (mpime.eq.ionode_id) THEN
#endif
      !
      OPEN(unit=epwdata,file='epwdata.fmt',status='old',iostat=ios)
      OPEN(unit=iundmedata,file='dmedata.fmt',status='old',iostat=ios)
      IF (eig_read) OPEN(unit=iunksdata,file='ksdata.fmt',status='old',iostat=ios)
      IF (vme) OPEN(unit=iunvmedata,file='vmedata.fmt',status='old',iostat=ios)
      IF (ios /= 0) call errore ('ephwann_shuffle', 'error opening epwdata.fmt',epwdata)
      READ (epwdata,*) ef
      READ (epwdata,*) nbndsub, nrr_k, nmodes, nrr_q
      READ (epwdata,*) lzstar
      READ (epwdata,*) zstar, epsi
      ! 
#ifdef __PARA
    ENDIF
    CALL mp_bcast (ef, ionode_id, inter_pool_comm)
    CALL mp_bcast (ef, root_pool, intra_pool_comm)
    !
    CALL mp_bcast (nbndsub, ionode_id, inter_pool_comm)
    CALL mp_bcast (nbndsub, root_pool, intra_pool_comm)
    !
    CALL mp_bcast (nrr_k, ionode_id, inter_pool_comm)
    CALL mp_bcast (nrr_k, root_pool, intra_pool_comm)
    !
    CALL mp_bcast (nmodes, ionode_id, inter_pool_comm)
    CALL mp_bcast (nmodes, root_pool, intra_pool_comm)
    !
    CALL mp_bcast (nrr_q, ionode_id, inter_pool_comm)
    CALL mp_bcast (nrr_q, root_pool, intra_pool_comm)
    !
    CALL mp_bcast (lzstar, ionode_id, inter_pool_comm)
    CALL mp_bcast (lzstar, root_pool, intra_pool_comm)
    !
    CALL mp_bcast (zstar, ionode_id, inter_pool_comm)
    CALL mp_bcast (zstar, root_pool, intra_pool_comm)
    !
    CALL mp_bcast (epsi, ionode_id, inter_pool_comm)
    CALL mp_bcast (epsi, root_pool, intra_pool_comm)
#endif
    !
    IF (.not. ALLOCATED(epmatwp)) ALLOCATE ( epmatwp ( nbndsub, nbndsub, nrr_k, nmodes) )
    IF (.not. ALLOCATED(chw)    ) ALLOCATE ( chw ( nbndsub, nbndsub, nrr_k )            )
    IF (.not. ALLOCATED(chw_ks) ) ALLOCATE ( chw_ks ( nbndsub, nbndsub, nrr_k )         )
    IF (.not. ALLOCATED(rdw)    ) ALLOCATE ( rdw ( nmodes,  nmodes,  nrr_q )            )
    IF (.not. ALLOCATED(cdmew)  ) ALLOCATE ( cdmew ( 3, nbndsub, nbndsub, nrr_k )       )
    IF (vme .and. (.not.ALLOCATED(cvmew))  ) ALLOCATE ( cvmew   ( 3, nbndsub, nbndsub, nrr_k )     )
    !
#ifdef __PARA
    IF (mpime.eq.ionode_id) THEN
#endif
       !
       DO ibnd = 1, nbndsub
          DO jbnd = 1, nbndsub
             DO irk = 1, nrr_k
                READ (epwdata,*) chw(ibnd,jbnd,irk)
                IF (eig_read) READ (iunksdata,*) chw_ks(ibnd,jbnd,irk)
                DO ipol = 1,3
                   READ (iundmedata,*) cdmew(ipol, ibnd,jbnd,irk)
                   IF (vme) READ (iunvmedata,*) cvmew(ipol, ibnd,jbnd,irk)
                ENDDO
             ENDDO
          ENDDO
       ENDDO
       !
       DO imode = 1, nmodes
          DO jmode = 1, nmodes
             DO irq = 1, nrr_q
                READ (epwdata,*) rdw(imode,jmode,irq)
             ENDDO
          ENDDO
       ENDDO
       !
#ifdef __PARA
    ENDIF
    !
    CALL mp_bcast (chw, ionode_id, inter_pool_comm)
    CALL mp_bcast (chw, root_pool, intra_pool_comm)
    !
    IF (eig_read) CALL mp_bcast (chw_ks, ionode_id, inter_pool_comm)
    IF (eig_read) CALL mp_bcast (chw_ks, root_pool, intra_pool_comm)
    !
    CALL mp_bcast (rdw, ionode_id, inter_pool_comm)
    CALL mp_bcast (rdw, root_pool, intra_pool_comm)
    !
    CALL mp_bcast (cdmew, ionode_id, inter_pool_comm)
    CALL mp_bcast (cdmew, root_pool, intra_pool_comm)
    !
    IF (vme) CALL mp_bcast (cvmew, ionode_id, inter_pool_comm)
    IF (vme) CALL mp_bcast (cvmew, root_pool, intra_pool_comm)
    !
#endif
    !
    ! CV: we don't need this (might change)
    !IF (.not.wepexst) THEN
    !DO irq = 1, nrr_q
      !
#ifdef __PARA
    !  IF (mpime.eq.ionode_id) THEN
#endif
         !
    !     DO ibnd = 1, nbndsub
    !        DO jbnd = 1, nbndsub
    !           DO irk = 1, nrr_k
    !              DO imode = 1, nmodes
    !                 READ (epwdata,*) epmatwp(ibnd,jbnd,irk,imode)
    !              ENDDO
    !           ENDDO
    !        ENDDO
    !     ENDDO
         !
#ifdef __PARA
    !  ENDIF
      !
    !  CALL mp_bcast (epmatwp, ionode_id, inter_pool_comm)
    !  CALL mp_bcast (epmatwp, root_pool, intra_pool_comm)
      !
#endif
      !
      ! direct write of epmatwp irq 
    !  CALL rwepmatwp ( nbndsub, nrr_k, nmodes, irq, iunepmatwp, +1)
      !
    !  IF (irq.eq.1) THEN
    !     WRITE(stdout,'(/5x,"Loading epwdata.fmt: ")',advance='no')
    !     indold = 0
    !  ENDIF
    !  indnew = nint(dble(irq)/dble(nrr_q)*43)
    !  IF (indnew.ne.indold) WRITE(stdout,'(a)',advance='no') '#'
    !  indold = indnew
      !
    !ENDDO
    !ENDIF
    !
#ifdef __PARA
    CALL mp_barrier(inter_pool_comm)
    IF (mpime.eq.ionode_id) THEN
#endif
      CLOSE(epwdata)
      CLOSE(iundmedata)
      IF (vme) CLOSE(iunvmedata)
#ifdef __PARA
    ENDIF
#endif
    !
    WRITE(stdout,'(/5x,"Finished reading Wann rep data from file"/)')
    !
!---------------------------------
END SUBROUTINE epw_read
!---------------------------------
!---------------------------------
SUBROUTINE mem_size(ibndmin, ibndmax, nmodes, nksqf, nxqf, fly) 
!---------------------------------
!
!  SUBROUTINE estimates the amount of memory taken up by 
!  the <k+q| dV_q,nu |k> on the fine meshes and prints 
!  out a useful(?) message   
!
  USE io_global,     ONLY : stdout
  USE kinds,         ONLY : DP
  !
  implicit none
  !
  integer :: imelt, ibndmin, ibndmax, nmodes, nksqf, nxqf
  real(kind=DP)    :: rmelt
  character (len=256) :: chunit
  logical :: fly
  !
  imelt = (ibndmax-ibndmin+1)**2 * nmodes * nksqf
  IF (.not.fly) imelt = imelt * nxqf
  rmelt = imelt * 8 / 1048576.d0 ! 8 bytes per number, value in Mb
  IF (rmelt .lt. 1000.0 ) THEN
     chunit =  ' Mb '
     IF (rmelt .lt. 1.0 ) THEN
        chunit = ' Kb '
        rmelt  = rmelt * 1024.d0
     ENDIF
  ELSE
     rmelt = rmelt / 1024.d0
     chunit = ' Gb '
  ENDIF
  WRITE(stdout,'(/,5x,a, i13, a,f7.2,a,a)') "Number of ep-matrix elements per pool :", &
       imelt, " ~= ", rmelt, trim(chunit), " (@ 8 bytes/ DP)"
  !

!---------------------------------
END SUBROUTINE mem_size
!---------------------------------

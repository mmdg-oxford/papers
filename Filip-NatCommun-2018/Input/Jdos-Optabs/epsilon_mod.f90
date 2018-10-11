!
! Copyright (C) 2004-2009 Andrea Benassi and Quantum ESPRESSO group
! This file is distributed under the terms of the
! GNU General Public License. See the file `License'
! in the root directory of the present distribution,
! or http://www.gnu.org/copyleft/gpl.txt .
!
!------------------------------
 MODULE grid_module
!------------------------------
  IMPLICIT NONE
  PRIVATE
  INTEGER, PARAMETER :: DP = selected_real_kind(14,200)
  !
  ! general purpose vars
  !
  INTEGER                     :: nw
  REAL(kind=DP)               :: wmax, wmin
  REAL(kind=DP)               :: alpha, full_occ
  REAL(kind=DP), ALLOCATABLE  :: focc(:,:), wgrid(:)
  !
  PUBLIC :: grid_build, grid_destroy
  PUBLIC :: nw, wmax, wmin
  PUBLIC :: focc, wgrid, alpha, full_occ
  !
CONTAINS

!---------------------------------------------
  SUBROUTINE grid_build(nw_, wmax_, wmin_, nelec, nbnd, nspin, nk)
  !-------------------------------------------
  !
  IMPLICIT NONE
  !
  INTEGER, PARAMETER :: DP = selected_real_kind(14,200)
  ! input vars
  INTEGER,  INTENT(IN) :: nw_, nelec, nbnd, nspin, nk
  REAL(kind=DP), INTENT(IN) :: wmax_ ,wmin_
  !
  ! local vars
  INTEGER :: iw,ik,i,ierr, nbnd_val
!  REAL(kind=DP) :: wk
  !
  ! check on the number of bands: we need to include empty bands in order to allow
  ! to write the transitions
  !
  IF ( nspin == 1) full_occ = 2.0d0
  IF ( nspin == 2 .OR. nspin == 4) full_occ = 1.0d0
  IF ( nspin == 1 .OR. nspin == 2) nbnd_val = nelec/2
  IF ( nspin == 4) nbnd_val = nelec
  !
  IF ( REAL(nbnd,DP)*full_occ <= nelec ) WRITE(6,*) "wrong band number / npin"
  !
  ! store data in module
  !
  nw = nw_
  wmax = wmax_
  wmin = wmin_
  !
  ! workspace
  !
!  wk=1.d0/dble(nk)
!  WRITE(6,*) " Weight wk = ",wk
  ALLOCATE ( focc( nbnd, nk), STAT=ierr )
  ALLOCATE( wgrid( nw ), STAT=ierr )
  IF (ierr/=0) WRITE(6,*) " grid_build allocating error"
  !
  ! occupation numbers, to be normalized differently
  ! whether we are spin resolved or not
  !
  focc = 0.d0
  DO ik = 1, nk
    DO i = 1, nbnd_val
        focc(i, ik) = full_occ
    ENDDO
  ENDDO
  !
  alpha = (wmax - wmin) / REAL(nw-1, KIND=DP)
  !
  DO iw = 1, nw
      wgrid(iw) = wmin + (iw-1) * alpha
  ENDDO
  !
END SUBROUTINE grid_build
!
!
!----------------------------------
  SUBROUTINE grid_destroy
  !----------------------------------
  IMPLICIT NONE
  INTEGER :: ierr
  !
  IF ( ALLOCATED( focc) ) THEN
      !
      DEALLOCATE ( focc, wgrid, STAT=ierr)
      !
  ENDIF
  !
END SUBROUTINE grid_destroy

END MODULE grid_module


!------------------------------
PROGRAM epsilon
!------------------------------
  !
  ! Compute the complex macroscopic dielectric function,
  ! at the RPA level, neglecting local field effects.
  ! Eps is computed both on the real or immaginary axis
  !
  ! Authors: 
  !     2006    Andrea Benassi, Andrea Ferretti, Carlo Cavazzoni:   basic implementation (partly taken from pw2gw.f90)
  !     2007    Andrea Benassi:                                     intraband contribution, nspin=2
  !     2016    Tae-Yun Kim, Cheol-Hwan Park:                       bugs fixed
  !     2016    Tae-Yun Kim, Cheol-Hwan Park, Andrea Ferretti:      non-collinear magnetism implemented
  !                                                                 code significantly restructured
  USE grid_module, ONLY : grid_build, grid_destroy
  !
  IMPLICIT NONE
  !
  INTEGER, PARAMETER :: DP = selected_real_kind(14,200)
  REAL(kind=DP), PARAMETER :: RYTOEV = 13.6056981d0
  REAL(kind=DP), PARAMETER :: HATOEV = 2.d0*RYTOEV
  REAL(kind=DP), PARAMETER :: PI=3.141592654
  CHARACTER(LEN=256), EXTERNAL :: trimcheck
  !
  ! input variables
  !
  INTEGER                 :: nw,nbndmin,nbndmax, nbnd, nelec, nspin
  REAL(kind=DP)           :: intersmear,wmax,wmin,shift
  CHARACTER(10)           :: calculation,prefix
  !
  NAMELIST / inputpp / prefix, calculation, nbnd, nelec, nspin
  NAMELIST / energy_grid / intersmear, nw, wmax, wmin, &
                           nbndmin, nbndmax, shift
  !
  ! local variables
  !
  CHARACTER(len=80) :: line
  INTEGER :: ios, stdout, ik, ibnd, nk, ierr, iw
  REAL(kind=DP) :: adum, fac
  REAL(DP), ALLOCATABLE :: et(:,:)
  REAL(DP), ALLOCATABLE :: wk(:)
  REAL(DP), ALLOCATABLE :: smear(:), matel(:), matel2(:)
  stdout = 6

!---------------------------------------------
! program body
!---------------------------------------------
!
  ! Set default values for variables in namelist
  !
  calculation  = 'jdos'
  prefix       = 'pwscf'
  shift        = 0.0d0
  intersmear   = 0.136
  wmin         = 0.0d0
  wmax         = 30.0d0
  nbndmin      = 1
  nbndmax      = 0
  nw           = 600
  !
  OPEN ( UNIT = 5, FILE = "epsilon.in", FORM = 'FORMATTED', STATUS = 'OLD', IOSTAT = ierr )
  !
  ! read input file
  !
  WRITE( stdout, "( 2/, 5x, 'Reading input file...' ) " )
  ios = 0
  !
  READ (5, inputpp, IOSTAT=ios)
  IF (ios/=0) WRITE(stdout, "( ' Error reading namelist INPUTPP' )")
  !
  READ (5, energy_grid, IOSTAT=ios)
  IF (ios/=0) WRITE(stdout, "( ' Error reading namelist ENERGY_GRID' )")
  !
  OPEN ( UNIT = 10, FILE = trim(prefix)//"_geninterp.kpt", FORM = 'FORMATTED', STATUS = 'OLD', IOSTAT = ierr )
  IF (ios/=0) WRITE(stdout, " ( ' Error reading geninterp.kpt' ) ")
  READ (10,*) line
  READ (10,*) line
  READ (10,*) nk
  CLOSE(10)
  !
  ALLOCATE(wk(nk))
  !
  OPEN ( UNIT = 12, FILE = trim(prefix)//"_geninterp.weight", FORM = 'FORMATTED', STATUS = 'OLD', IOSTAT = ierr )
  IF (ios/=0) WRITE(stdout, " ( ' Error reading geninterp.weight' ) ")
  !
  DO ik = 1, nk
        READ (12,*)wk(ik)
        WRITE (*,*) wk(ik)
  ENDDO
  CLOSE(12)
  !
  !
  ALLOCATE (et(nbnd,nk))
  !
  OPEN ( UNIT = 11, FILE = trim(prefix)//"_geninterp.dat", FORM = 'FORMATTED', STATUS = 'OLD', IOSTAT = ierr )
  IF (ios/=0) WRITE(stdout, "(' Error reading geninterp.dat ')")
  READ (11,*) line
  READ (11,*) line
  READ (11,*) line
  DO ik = 1, nk
     DO ibnd = 1, nbnd
        READ (11,*) adum, adum, adum, adum, et(ibnd,ik)
        ! et=energy in eV
     ENDDO
     IF (MOD(ik,10000).eq.0) WRITE(stdout,*) ik, et(nbnd,ik)
  ENDDO
  CLOSE(11)
  !
  ALLOCATE (smear(nw))
  OPEN ( UNIT = 13, FILE = "smear.dat", FORM = 'FORMATTED', STATUS = 'OLD', IOSTAT = ierr )
  IF (ios/=0) WRITE(stdout, "(' Error reading smear.dat ')")
  DO iw = 1, nw
     READ (13,*) adum, adum
     smear(iw)=adum*0.001*2.d0
  ENDDO
  CLOSE(13)
  WRITE(stdout,*) " SMEAR ",smear(1),smear(nw)
  !
  fac=4.d0*PI*PI/6418.1229
  ALLOCATE (matel(nk))
  OPEN ( UNIT = 14, FILE = "matel-data.dat", FORM = 'FORMATTED', STATUS = 'OLD',IOSTAT = ierr )
  IF (ios/=0) WRITE(stdout, "(' Error reading matel-data.dat ')")
  DO iw = 1, nk
     READ (14,*) adum
     matel(iw)=fac*adum/4.d0
  ENDDO
  CLOSE(14)
  WRITE(stdout,*) " MATEL ",matel(nk)

  ALLOCATE (matel2(nk))
  OPEN ( UNIT = 15, FILE = "matel-data2.dat", FORM = 'FORMATTED', STATUS = 'OLD',IOSTAT = ierr )
  IF (ios/=0) WRITE(stdout, "(' Error reading matel-data2.dat ')")
  DO iw = 1, nk
     READ (15,*) adum
     matel2(iw)=fac*adum/4.d0
  ENDDO
  CLOSE(15)
  WRITE(stdout,*) " MATEL2 ",matel2(nk)
  !
  ! few conversions
  !
  IF (nbndmax == 0) nbndmax = nbnd
  !
  ! perform some consistency checks, 
  ! setup w-grid and occupation numbers
  !
  CALL grid_build(nw, wmax, wmin, nelec, nbnd, nspin, nk)
  !
  ! ... run the specific pp calculation
  !
  WRITE(stdout,"(/, 5x, 'Performing ',a,' calculation...')") trim(calculation)
  WRITE(stdout,*) ' Smearing (eV) ', intersmear
  !
  CALL jdos_calc ( intersmear, nbndmin, nbndmax, shift, nspin, nbnd, nk, et , wk, smear, matel, matel2)
  !
  ! cleaning
  !
  CALL grid_destroy()
  !
END PROGRAM epsilon
!
!----------------------------------------------------------------------------------------
SUBROUTINE jdos_calc ( intersmear, nbndmin, nbndmax, shift, nspin, nbnd, nk, et , wk, smear, matel, matel2)
  !--------------------------------------------------------------------------------------
  !
  USE grid_module,          ONLY : alpha, focc, nw, wgrid
  !
  IMPLICIT NONE
  INTEGER, PARAMETER :: DP = selected_real_kind(14,200)
  REAL(kind=DP), PARAMETER :: PI = 3.14159265358979323846_DP
  REAL(kind=DP), PARAMETER :: RYTOEV = 13.6056981d0
  REAL(kind=DP), PARAMETER :: HATOEV = 2.d0*RYTOEV
  !
  ! input variables
  !
  INTEGER,      INTENT(IN) :: nbndmin, nbndmax, nspin, nbnd, nk
  REAL(kind=DP),     INTENT(IN) :: intersmear, shift, et(nbnd,nk), wk(nk), smear(nw), matel(nk), matel2(nk)
  !
  ! local variables
  !
  INTEGER  :: ik, is, iband1, iband2
  INTEGER  :: iw, ierr, stdout
  REAL(kind=DP) :: etrans, w, renorm, count, srcount(0:1), renormzero,renormuno, weight, ismear
  !
  CHARACTER(128)        :: desc
  REAL(kind=DP), ALLOCATABLE :: jdos(:),srjdos(:,:), epsil(:)
  stdout=6
  !
  !--------------------------
  ! main routine body
  !--------------------------
  !
  ! No wavefunctions are needed in order to compute jdos, only eigenvalues,
  ! they are distributed to each task so
  ! no mpi calls are necessary in this routine
  !
!
! spin unresolved calculation
!
IF (nspin==1 .or. nspin==4) THEN
  !
  ! allocate main spectral and auxiliary quantities
  !
  ALLOCATE( jdos(nw), STAT=ierr )
  ALLOCATE( epsil(nw), STAT=ierr )
  !
  ! initialize jdos
  !
  jdos(:)=0.0_DP
  epsil(:)=0.d0

  ! Initialising a counter for the number of transition
  count=0.0_DP
  !
  ! main kpt loop
  !
  kpt_gauss: &
  DO ik = 1, nk
     !
     ! Calculation of joint density of states
     ! 'intersmear' is the brodening parameter
     !
     DO iband2 = nbndmin,nbndmax
     DO iband1 = nbndmin,nbndmax
        !
        IF ( focc(iband2,ik) <  1.0d0) THEN
        IF ( focc(iband1,ik) >= 1.0d-4 ) THEN
           !
           ! transition energy (et already in eV)
           !
           etrans = ( et(iband2,ik) -et(iband1,ik) ) + shift
           !
           IF( etrans < 1.0d-10 ) CYCLE
             ! loop over frequencies
             !
             count=count+ (focc(iband1,ik)-focc(iband2,ik))
             DO iw = 1, nw
                !
                w = wgrid(iw)
                ismear=smear(iw)
                !
                if ( (iband1.eq.71 .or. iband1.eq.72) .and. (iband2.eq.73 .or. iband2.eq.74) ) then 
                  epsil(iw) = epsil(iw) + matel(ik)*exp(-(etrans-w)**2/ismear**2)/(ismear/HATOEV * sqrt(PI))*wk(ik)
                endif
                if ( (iband1.eq.69 .or. iband1.eq.70) .and. (iband2.eq.73 .or.iband2.eq.74) ) then
                  epsil(iw) = epsil(iw) + matel2(ik)*exp(-(etrans-w)**2/ismear**2)/(ismear/HATOEV * sqrt(PI))*wk(ik)
                endif
                jdos(iw) = jdos(iw) + (focc(iband1,ik)-focc(iband2,ik)) * &
                           exp(-(etrans-w)**2/ismear**2) &
                           / (ismear * sqrt(PI))*wk(ik)
!                          exp(-(etrans-w)**2/((10.3333d0*w-4.1666d0)*intersmear)**2) &
!                          / (((10.3333d0*w-4.1666d0)*intersmear)* sqrt(PI))*wk(ik)
!                            exp(-(etrans-w)**2/intersmear**2) &
!                            / (intersmear * sqrt(PI))*wk(ik)
!                           exp(-(etrans-w)**2/((120.0d0*w-59.0d0)*intersmear)**2) &
!                           / (((120.0d0*w-59.0d0)*intersmear)* sqrt(PI))*wk(ik)
!                           exp(-(etrans-w)**2/(intersmear+0.049d0*w/6.0d0)**2) &
!                           / ((intersmear+0.049d0*w/6.0d0)* sqrt(PI))*wk(ik)
!*10000

             ENDDO
             !  
        ENDIF
        ENDIF
     ENDDO

     ENDDO
     !
  ENDDO kpt_gauss
  write(stdout,*) "COUNT ",count
  !
  ! jdos normalizzation
  !
!  jdos(:)=jdos(:)/count
  renorm = alpha * sum( jdos(:) )

  !
  ! write results on data files
  !
  WRITE(stdout,"(/,5x, 'Integration over JDOS gives: ',f15.9,' instead of 1.0d0' )") renorm
  WRITE(stdout,"(/,5x, 'Writing output on file...' )")
  !
  desc = "energy grid [eV]     JDOS [1/eV]"
  CALL eps_writetofile('jdos',desc,nw,wgrid,1,jdos,epsil)
  !
  ! local cleaning
  !
  DEALLOCATE ( jdos )

!
! collinear spin calculation
!
ELSEIF(nspin==2) THEN
  !
  ! allocate main spectral and auxiliary quantities
  !
  ALLOCATE( srjdos(0:1,nw), STAT=ierr )
  !
  ! initialize jdos
  !
  srjdos(:,:)=0.0_DP

  ! Initialising a counter for the number of transition
  srcount(:)=0.0_DP
  !
  ! main kpt loop
  !
  DO is=0,1
    ! if nspin=2 the number of nks must be even (even if the calculation
    ! is performed at gamma point only), so nks must be always a multiple of 2
    DO ik = 1 + is * int(nk/2), int(nk/2) +  is * int(nk/2)
       !
       ! Calculation of joint density of states
       ! 'intersmear' is the brodening parameter
       !
       DO iband2 = nbndmin,nbndmax
       DO iband1 = nbndmin,nbndmax
           !
           IF ( focc(iband2,ik) <  2.0d0) THEN
           IF ( focc(iband1,ik) >= 1.0d-4 ) THEN
                 !
                 ! transition energy
                 !
                 etrans = ( et(iband2,ik) -et(iband1,ik) ) * RYTOEV  + shift
                 !
                 IF( etrans < 1.0d-10 ) CYCLE

                 ! loop over frequencies
                 !

                 srcount(is)=srcount(is)+ (focc(iband1,ik)-focc(iband2,ik))

                 DO iw = 1, nw
                     !
                     w = wgrid(iw)
                     !
                     srjdos(is,iw) = srjdos(is,iw) + (focc(iband1,ik)-focc(iband2,ik)) * &
                                exp(-(etrans-w)**2/intersmear**2) &
                                  / (intersmear * sqrt(PI))*wk(ik)

                 ENDDO

           ENDIF
           ENDIF
       ENDDO
       ENDDO
    ENDDO
 ENDDO
  !
  ! jdos normalizzation
  !
  DO is = 0,1
    srjdos(is,:)=srjdos(is,:)/srcount(is)
  ENDDO
  !
  renormzero = alpha * sum( srjdos(0,:) )
  renormuno  = alpha * sum( srjdos(1,:) )
  !
  ! write results on data files
  !
  WRITE(stdout,"(/,5x, 'Integration over spin UP JDOS gives: ',f15.9,' instead of 1.0d0' )") renormzero
  WRITE(stdout,"(/,5x, 'Integration over spin DOWN JDOS gives: ',f15.9,' instead of 1.0d0' )") renormuno
  WRITE(stdout,"(/,5x, 'Writing output on file...' )")
  !
  desc = "energy grid [eV]     UJDOS [1/eV]      DJDOS[1/eV]"
  CALL eps_writetofile('jdos',desc,nw,wgrid,2,srjdos(0:1,:))
  !
  DEALLOCATE ( srjdos )
ENDIF

END SUBROUTINE jdos_calc
!
!--------------------------------------------------------------------
SUBROUTINE eps_writetofile(namein,desc,nw,wgrid,ncol,var,epsil)
  !------------------------------------------------------------------
  !
  IMPLICIT NONE
  INTEGER, PARAMETER :: DP = selected_real_kind(14,200)
  !
  CHARACTER(LEN=*),   INTENT(IN) :: namein
  CHARACTER(LEN=*),   INTENT(IN) :: desc
  INTEGER,            INTENT(IN) :: nw, ncol
  REAL(kind=DP),           INTENT(IN) :: wgrid(nw)
  REAL(kind=DP),           INTENT(IN) :: var(ncol,nw)
  REAL(kind=DP),           INTENT(IN) :: epsil(nw)
  !
  CHARACTER(256) :: str
  INTEGER        :: iw
  
  str = TRIM(namein) // ".dat"
  OPEN(40,FILE=TRIM(str))
  ! 
  WRITE(40,"(a)") "# "// TRIM(desc)
  WRITE(40,"(a)") "#"
  !
  DO iw = 1, nw
     !     
     WRITE(40,"(10f15.9)") wgrid(iw), var(1:ncol,iw), epsil(iw)
     !
  ENDDO
  !
  CLOSE(40)
  !
END SUBROUTINE eps_writetofile

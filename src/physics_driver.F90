module physics

    implicit none

    public :: phys_state_t, &
              physics_init, &
              physics_driver

    private

    !-----------------------------------------------------------------------
    ! Derived type for storing state on which the physics will operate
    !-----------------------------------------------------------------------
    type phys_state_t
        real :: t = 273.15     ! Temperature (K)
        real :: p = 101325.0   ! Pressure (Pa)
        real :: u = 0.0        ! Zonal wind (m/s)
        real :: v = 1.0        ! Meridional wind (m/s)
        real :: qv = 0.010     ! Water vapor mixing ratio (kg/kg)
        real :: qc = 0.0       ! Cloud water mixing ratio (kg/kg)
        real :: qr = 0.0       ! Rain mixing ratio (kg/kg)
        real :: qi = 0.0       ! Cloud ice mixing ratio (kg/kg)
        real :: qs = 0.0       ! Snow mixing ratio (kg/kg)
        real :: qg = 0.0       ! Graupel mixing ratio (kg/kg)
    end type phys_state_t


contains


    !-----------------------------------------------------------------------
    !  routine physics_init
    !
    !> \brief Initialize the physics
    !> \details
    !>  This routine initializes the physics to be used in the toy model
    !>  and must be called before any subsequent calls to the physics_driver.
    !
    !-----------------------------------------------------------------------
    subroutine physics_init()

        use mgd_microphysics, only : mgd_mp_init
        use ldf_microphysics, only : ldf_mp_init


        write(0,*) 'Initializing the physics...'

        call mgd_mp_init()
        call ldf_mp_init()

    end subroutine physics_init


    !-----------------------------------------------------------------------
    !  routine physics_driver
    !
    !> \brief Main physics driver for the toy model
    !> \details
    !>  Provides a direct update of state in a phys_state_t instance using
    !>  a suite of physics parameterizations.
    !
    !-----------------------------------------------------------------------
    subroutine physics_driver(pstate)

        use mgd_microphysics, only : mgd_mp
        use ldf_microphysics, only : ldf_mp

        type (phys_state_t), intent(inout) :: pstate


        write(0,*) 'Calling the physics...'

        call mgd_mp(pstate % t, &
                    pstate % p, &
                    pstate % qv &
                   )
        call ldf_mp(pstate % qc, &
                    pstate % qr, &
                    pstate % qi, &
                    pstate % qs, &
                    pstate % qg  &
                   )
        write(0,*)

    end subroutine physics_driver

end module physics

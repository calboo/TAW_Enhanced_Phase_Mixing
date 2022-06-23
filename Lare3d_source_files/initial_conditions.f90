MODULE initial_conditions

  USE shared_data
  USE neutral

  IMPLICIT NONE

  PRIVATE

  PUBLIC :: set_initial_conditions

CONTAINS

  !****************************************************************************
  ! This function sets up the initial condition for the code
  ! The variables which must be set are:
  !   rho - density
  !   v{x,y,z} - Velocities in x, y, z
  !   b{x,y,z} - Magnetic fields in x, y, z
  !   energy - Specific internal energy
  !
  ! You may also need the neutral fraction. This can be calculated by a
  ! function call to get_neutral(temperature, rho, z). This routine is in
  ! core/neutral.f90 and requires the local temperature and mass density.
  ! For example to set xi_n to the neutral fraction use:
  !   xi_n = get_neutral(temperature, rho, z)
  !****************************************************************************

  SUBROUTINE set_initial_conditions

  INTEGER :: ix, iy, iz
  REAL(num) :: beta, r, psi, psib, rhohat

! Gravity and beta 

  grav=0.0_num
  beta = 1.0e-8_num 

! Velocities
! Static domain.

  vx = 0.0_num
  vy = 0.0_num
  vz = 0.0_num

! Magnetic Field

  DO ix = -2, nx+2
     DO iy = -1, ny+2
         DO iz = -1, nz+2
            r = sqrt(xb(ix)**2+yc(iy)**2)
            bx(ix,iy,iz)= b0*exp(-zc(iz)/H)*bessel_j1(r/H)*(xb(ix)/r)
         END DO
     END DO
  END DO

  DO ix = -1, nx+2
     DO iy = -2, ny+2
         DO iz = -1, nz+2
            r = sqrt(xc(ix)**2+yb(iy)**2)
            by(ix,iy,iz)= b0*exp(-zc(iz)/H)*bessel_j1(r/H)*(yb(iy)/r)
         END DO
     END DO
  END DO

  DO ix = -1, nx+2
     DO iy = -1, ny+2
         DO iz = -2, nz+2
            r = sqrt(xc(ix)**2+yc(iy)**2)
            bz(ix,iy,iz)= b0*exp(-zb(iz)/H)*bessel_j0(r/H)
         END DO 
     END DO
  END DO

! Density

  psib = r0**2/(2.0_num*H)

  DO iy= -1,ny+2 
     DO iz = -1,nz+2 
         DO ix = -1,nx+2 
             r = sqrt(xc(ix)**2+yc(iy)**2)
             psi = r*exp(-zc(iz)/H)*bessel_j1(r/H)
             if (psi .LE. psib) then
                rhohat = (1.0_num+(zeta-1.0_num)*((1.0_num-(psi/psib))**2))/zeta
             else
                rhohat = 1.0_num/zeta
             endif
             rho(ix,iy,iz) = rhohat*exp(-rho_alpha*zc(iz)/H)
          END DO
     END DO
  END DO

! Energy
! The energy has been set such that the pressure will equal beta/2 everywhere.

  energy=0.5_num*(beta*1.0_num) / ((rho) * (gamma-1.0_num))

! Store Initial Values
! Initial values are stored in these arrays.

  ALLOCATE(rho0(-1:nx+2, -1:ny+2, -1:nz+2))
  ALLOCATE(bx0 (-2:nx+2, -1:ny+2, -1:nz+2))
  ALLOCATE(by0 (-1:nx+2, -2:ny+2, -1:nz+2))
  ALLOCATE(bz0 (-1:nx+2, -1:ny+2, -2:nz+2))
  ALLOCATE(energy0(-1:nx+2, -1:ny+2, -1:nz+2))

  bx0 = bx
  by0 = by
  bz0 = bz
  rho0 = rho
  energy0 = energy

  max_vx = 0.0_num
  max_bx = 0.0_num

! set background, non-shock, viscosity

    visc3 = 7.22e-6_num

  END SUBROUTINE set_initial_conditions

END MODULE initial_conditions

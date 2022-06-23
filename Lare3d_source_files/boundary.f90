!******************************************************************************
! This module contains the boundary conditions for the entire code
! Any new boundary conditions should be added here
!******************************************************************************

MODULE boundary

  USE shared_data
  USE mpiboundary

  IMPLICIT NONE

CONTAINS

  !****************************************************************************
  ! Set up any necessary variables for the chosen boundary conditions
  !****************************************************************************

  SUBROUTINE set_boundary_conditions

    any_open = .FALSE.
    IF (xbc_min == BC_OPEN .OR. xbc_max == BC_OPEN &
        .OR. ybc_min == BC_OPEN .OR. ybc_max == BC_OPEN &
        .OR. zbc_min == BC_OPEN .OR. zbc_max == BC_OPEN) any_open = .TRUE.

  END SUBROUTINE set_boundary_conditions



  !****************************************************************************
  ! Call all of the boundaries needed by the core Lagrangian solver
  !****************************************************************************

  SUBROUTINE boundary_conditions

    CALL bfield_bcs
    CALL energy_bcs
    CALL density_bcs
    CALL velocity_bcs
    CALL damp_boundaries

  END SUBROUTINE boundary_conditions



  !****************************************************************************
  ! Boundary conditions for magnetic field through plane
  !****************************************************************************

  SUBROUTINE bfield_bcs

  INTEGER :: ix, iy, iz
  REAL(num) ::  r

    CALL bfield_mpi

   IF (proc_x_min == MPI_PROC_NULL .AND. xbc_min == BC_USER) THEN
      bx(-1,:,:) = bx0(-1,:,:)+(bx(1,:,:)-bx0(1,:,:))
      bx(-2,:,:) = bx0(-2,:,:)+(bx(2,:,:)-bx0(2,:,:))
      by( 0,:,:) = by0( 0,:,:)+(by(1,:,:)-by0(1,:,:))
      by(-1,:,:) = by0(-1,:,:)+(by(2,:,:)-by0(2,:,:))
      bz( 0,:,:) = bz0( 0,:,:)+(bz(1,:,:)-bz0(1,:,:))
      bz(-1,:,:) = bz0(-1,:,:)+(bz(2,:,:)-bz0(2,:,:))
    END IF

    IF (proc_x_max == MPI_PROC_NULL .AND. xbc_max == BC_USER) THEN
      bx(nx+1,:,:) = bx0(nx+1,:,:)+(bx(nx-1,:,:)-bx0(nx-1,:,:))
      bx(nx+2,:,:) = bx0(nx+2,:,:)+(bx(nx-2,:,:)-bx0(nx-2,:,:))
      by(nx+1,:,:) = by0(nx+1,:,:)+(by(nx  ,:,:)-by0(nx  ,:,:))
      by(nx+2,:,:) = by0(nx+2,:,:)+(by(nx-1,:,:)-by0(nx-1,:,:))
      bz(nx+1,:,:) = bz0(nx+1,:,:)+(bz(nx  ,:,:)-bz0(nx  ,:,:))
      bz(nx+2,:,:) = bz0(nx+2,:,:)+(bz(nx-1,:,:)-bz0(nx-1,:,:))
    END IF

    IF (proc_y_min == MPI_PROC_NULL .AND. ybc_min == BC_USER) THEN
      bx(:, 0,:) = bx0(:, 0,:)+(bx(:,1,:)-bx0(:,1,:))
      bx(:,-1,:) = bx0(:,-1,:)+(bx(:,2,:)-bx0(:,2,:))
      by(:,-1,:) = by0(:,-1,:)+(by(:,1,:)-by0(:,1,:))
      by(:,-2,:) = by0(:,-2,:)+(by(:,2,:)-by0(:,2,:))
      bz(:, 0,:) = bz0(:, 0,:)+(bz(:,1,:)-bz0(:,1,:))
      bz(:,-1,:) = bz0(:,-1,:)+(bz(:,2,:)-bz0(:,2,:))
    END IF

    IF (proc_y_max == MPI_PROC_NULL .AND. ybc_max == BC_USER) THEN
      bx(:,ny+1,:) = bx0(:,ny+1,:)+(bx(:,ny  ,:)-bx0(:,ny  ,:))
      bx(:,ny+2,:) = bx0(:,ny+2,:)+(bx(:,ny-1,:)-bx0(:,ny-1,:))
      by(:,ny+1,:) = by0(:,ny+1,:)+(by(:,ny-1,:)-by0(:,ny-1,:))
      by(:,ny+2,:) = by0(:,ny+2,:)+(by(:,ny-2,:)-by0(:,ny-2,:))
      bz(:,ny+1,:) = bz0(:,ny+1,:)+(bz(:,ny  ,:)-bz0(:,ny  ,:))
      bz(:,ny+2,:) = bz0(:,ny+2,:)+(bz(:,ny-1,:)-bz0(:,ny-1,:))
    END IF

    IF (proc_z_min == MPI_PROC_NULL .AND. zbc_min == BC_USER) THEN
     DO ix = -2, nx+2
        DO iy = -1, ny+2
          DO iz = -1,0
            r = sqrt(xb(ix)**2+yc(iy)**2)
            if (r .LE. r0) then
               bx(ix,iy,iz) = bx0(ix,iy,iz) + v0*(yc(iy)/r0)* &
                    sqrt(rho(ix,iy,iz))* &
                    (1.0_num-(r/r0)**2)*sin(omega*time)* &
                    (1-exp(-(time/t0)**3))
            else
               bx(ix,iy,iz) = bx0(ix,iy,iz)
            endif
          END DO
        END DO
      END DO
      DO ix = -1, nx+2
        DO iy = -2, ny+2
          DO iz = -1,0
            r = sqrt(xc(ix)**2+yb(iy)**2)
            if (r .LE. r0) then
               by(ix,iy,iz) = by0(ix,iy,iz) - v0*(xc(ix)/r0)* &
                    sqrt(rho(ix,iy,iz))* &
                    (1.0_num-(r/r0)**2)*sin(omega*time)* &
                    (1-exp(-(time/t0)**3))
            else
               by(ix,iy,iz) = by0(ix,iy,iz)
            endif            
          END DO
        END DO
      END DO
      bz(:,:,-1) = bz0(:,:,-1)+(bz(:,:,1)-bz0(:,:,1))
      bz(:,:,-2) = bz0(:,:,-2)+(bz(:,:,2)-bz0(:,:,2))
    END IF

    IF (proc_z_max == MPI_PROC_NULL .AND. zbc_max == BC_USER) THEN
      bx(:,:,nz+1) = bx0(:,:,nz+1)+(bx(:,:,nz  )-bx0(:,:,nz  ))
      bx(:,:,nz+2) = bx0(:,:,nz+2)+(bx(:,:,nz-1)-bx0(:,:,nz-1))
      by(:,:,nz+1) = by0(:,:,nz+1)+(by(:,:,nz  )-by0(:,:,nz  ))
      by(:,:,nz+2) = by0(:,:,nz+2)+(by(:,:,nz-1)-by0(:,:,nz-1))
      bz(:,:,nz+1) = bz0(:,:,nz+1)+(bz(:,:,nz-1)-bz0(:,:,nz-1))
      bz(:,:,nz+2) = bz0(:,:,nz+2)+(bz(:,:,nz-2)-bz0(:,:,nz-2))
    END IF

    max_bx = max(max_bx,abs(bx))

  END SUBROUTINE bfield_bcs



  !****************************************************************************
  ! Boundary conditions for specific internal energy
  !****************************************************************************

  SUBROUTINE energy_bcs

    CALL energy_mpi

    IF (proc_x_min == MPI_PROC_NULL .AND. xbc_min == BC_USER) THEN
      energy( 0,:,:) = energy0( 0,:,:)
      energy(-1,:,:) = energy0(-1,:,:)
    END IF

    IF (proc_x_max == MPI_PROC_NULL .AND. xbc_max == BC_USER) THEN
      energy(nx+1,:,:) = energy0(nx+1,:,:)
      energy(nx+2,:,:) = energy0(nx+2,:,:)
    END IF

    IF (proc_y_min == MPI_PROC_NULL .AND. ybc_min == BC_USER) THEN
      energy(:, 0,:) = energy0(:, 0,:)
      energy(:,-1,:) = energy0(:,-1,:)
    END IF

    IF (proc_y_max == MPI_PROC_NULL .AND. ybc_max == BC_USER) THEN
      energy(:,ny+1,:) = energy0(:,ny+1,:)
      energy(:,ny+2,:) = energy0(:,ny+2,:)
    END IF

    IF (proc_z_min == MPI_PROC_NULL .AND. zbc_min == BC_USER) THEN
      energy(:,:, 0) = energy0(:,:, 0)
      energy(:,:,-1) = energy0(:,:,-1)
    END IF

    IF (proc_z_max == MPI_PROC_NULL .AND. zbc_max == BC_USER) THEN
      energy(:,:,nz+1) = energy0(:,:,nz+1)
      energy(:,:,nz+2) = energy0(:,:,nz+2)
    END IF

  END SUBROUTINE energy_bcs



  !****************************************************************************
  ! Boundary conditions for density
  !****************************************************************************

   SUBROUTINE density_bcs

    CALL density_mpi

    IF (proc_x_min == MPI_PROC_NULL .AND. xbc_min == BC_USER) THEN
      rho( 0,:,:) = rho0( 0,:,:)
      rho(-1,:,:) = rho0(-1,:,:)
    END IF

    IF (proc_x_max == MPI_PROC_NULL .AND. xbc_max == BC_USER) THEN
      rho(nx+1,:,:) = rho0(nx+1,:,:)
      rho(nx+2,:,:) = rho0(nx+2,:,:)
    END IF

    IF (proc_y_min == MPI_PROC_NULL .AND. ybc_min == BC_USER) THEN
      rho(:, 0,:) = rho0(:, 0,:)
      rho(:,-1,:) = rho0(:,-1,:)
    END IF

    IF (proc_y_max == MPI_PROC_NULL .AND. ybc_max == BC_USER) THEN
      rho(:,ny+1,:) = rho0(:,ny+1,:)
      rho(:,ny+2,:) = rho0(:,ny+2,:)
    END IF

    IF (proc_z_min == MPI_PROC_NULL .AND. zbc_min == BC_USER) THEN
      rho(:,:, 0) = rho0(:,:, 0)
      rho(:,:,-1) = rho0(:,:,-1)
    END IF

    IF (proc_z_max == MPI_PROC_NULL .AND. zbc_max == BC_USER) THEN
      rho(:,:,nz+1) = rho0(:,:,nz+1)
      rho(:,:,nz+2) = rho0(:,:,nz+1)
    END IF

  END SUBROUTINE density_bcs


  !****************************************************************************
  ! Boundary conditions for temperature
  !****************************************************************************

  SUBROUTINE temperature_bcs

    CALL density_mpi

    IF (proc_x_min == MPI_PROC_NULL .AND. xbc_min == BC_USER) THEN
      temperature( 0,:,:) = temperature(1,:,:)
      temperature(-1,:,:) = temperature(2,:,:)
    END IF

    IF (proc_x_max == MPI_PROC_NULL .AND. xbc_max == BC_USER) THEN
      temperature(nx+1,:,:) = temperature(nx  ,:,:)
      temperature(nx+2,:,:) = temperature(nx-1,:,:)
    END IF

    IF (proc_y_min == MPI_PROC_NULL .AND. ybc_min == BC_USER) THEN
      temperature(:, 0,:) = temperature(:,1,:)
      temperature(:,-1,:) = temperature(:,2,:)
    END IF

    IF (proc_y_max == MPI_PROC_NULL .AND. ybc_max == BC_USER) THEN
      temperature(:,ny+1,:) = temperature(:,ny  ,:)
      temperature(:,ny+2,:) = temperature(:,ny-1,:)
    END IF

    IF (proc_z_min == MPI_PROC_NULL .AND. zbc_min == BC_USER) THEN
      temperature(:,:, 0) = temperature(:,:,1)
      temperature(:,:,-1) = temperature(:,:,2)
    END IF

    IF (proc_z_max == MPI_PROC_NULL .AND. zbc_max == BC_USER) THEN
      temperature(:,:,nz+1) = temperature(:,:,nz  )
      temperature(:,:,nz+2) = temperature(:,:,nz-1)
    END IF

  END SUBROUTINE temperature_bcs



  !****************************************************************************
  ! Full timestep velocity boundary conditions
  !****************************************************************************

  SUBROUTINE velocity_bcs

    INTEGER :: ix, iy, iz
    REAL(num) ::  r

    CALL velocity_mpi

    IF (proc_x_min == MPI_PROC_NULL .AND. xbc_min == BC_USER) THEN
      vx(-2:0,:,:) = 0.0_num
      vy(-2:0,:,:) = 0.0_num
      vz(-2:0,:,:) = 0.0_num
    END IF

    IF (proc_x_max == MPI_PROC_NULL .AND. xbc_max == BC_USER) THEN
      vx(nx:nx+2,:,:) = 0.0_num
      vy(nx:nx+2,:,:) = 0.0_num
      vz(nx:nx+2,:,:) = 0.0_num
    END IF

    IF (proc_y_min == MPI_PROC_NULL .AND. ybc_min == BC_USER) THEN
      vx(:,-2:0,:) = 0.0_num
      vy(:,-2:0,:) = 0.0_num
      vz(:,-2:0,:) = 0.0_num
    END IF

    IF (proc_y_max == MPI_PROC_NULL .AND. ybc_max == BC_USER) THEN
      vx(:,ny:ny+2,:) = 0.0_num
      vy(:,ny:ny+2,:) = 0.0_num
      vz(:,ny:ny+2,:) = 0.0_num
    END IF

    IF (proc_z_min == MPI_PROC_NULL .AND. zbc_min == BC_USER) THEN
       DO ix = -2, nx+2
          DO iy = -2, ny+2
             DO iz = -2,0
                r = sqrt(xb(ix)**2+yb(iy)**2)
                if (r .LE. r0) then
                   vx(ix,iy,iz) = -v0*(yb(iy)/r0)* &
                        (1.0_num-(r/r0)**2)*sin(omega*time)* &
                        (1-exp(-(time/t0)**3))
                else
                   vx(ix,iy,iz) = 0.0_num
                endif 
             END DO
          END DO
       END DO
       DO ix = -2, nx+2
          DO iy = -2, ny+2
             DO iz = -2,0
                r = sqrt(xb(ix)**2+yb(iy)**2)
                if (r .LE. r0) then
                   vy(ix,iy,iz) = v0*(xb(ix)/r0)* &
                        (1.0_num-(r/r0)**2)*sin(omega*time)* &
                        (1-exp(-(time/t0)**3))
                else
                   vy(ix,iy,iz) = 0.0_num
                endif          
             END DO
          END DO
       END DO
       vz(:,:,-2:0) = 0.0_num
    END IF

    IF (proc_z_max == MPI_PROC_NULL .AND. zbc_max == BC_USER) THEN
      vx(:,:,nz:nz+2) = 0.0_num
      vy(:,:,nz:nz+2) = 0.0_num
      vz(:,:,nz:nz+2) = 0.0_num
    END IF

    max_vx = max(max_vx,abs(vx))

  END SUBROUTINE velocity_bcs



  !****************************************************************************
  ! Half timestep velocity boundary conditions
  !****************************************************************************

  SUBROUTINE remap_v_bcs

    INTEGER :: ix, iy, iz
    REAL(num) ::  r

    CALL remap_v_mpi

    IF (proc_x_min == MPI_PROC_NULL .AND. xbc_min == BC_USER) THEN
      vx1(-2:0,:,:) = 0.0_num
      vy1(-2:0,:,:) = 0.0_num
      vz1(-2:0,:,:) = 0.0_num
    END IF

    IF (proc_x_max == MPI_PROC_NULL .AND. xbc_max == BC_USER) THEN
      vx1(nx:nx+2,:,:) = 0.0_num
      vy1(nx:nx+2,:,:) = 0.0_num
      vz1(nx:nx+2,:,:) = 0.0_num
    END IF

    IF (proc_y_min == MPI_PROC_NULL .AND. ybc_min == BC_USER) THEN
      vx1(:,-2:0,:) = 0.0_num
      vy1(:,-2:0,:) = 0.0_num
      vz1(:,-2:0,:) = 0.0_num
    END IF

    IF (proc_y_max == MPI_PROC_NULL .AND. ybc_max == BC_USER) THEN
      vx1(:,ny:ny+2,:) = 0.0_num
      vy1(:,ny:ny+2,:) = 0.0_num
      vz1(:,ny:ny+2,:) = 0.0_num
    END IF

    IF (proc_z_min == MPI_PROC_NULL .AND. zbc_min == BC_USER) THEN
       DO ix = -2, nx+2
          DO iy = -2, ny+2
             DO iz = -2,0
                r = sqrt(xb(ix)**2+yb(iy)**2)
                if (r .LE. r0) then
                   vx1(ix,iy,iz) = -v0*(yb(iy)/r0)* &
                        (1.0_num-(r/r0)**2)*sin(omega*time)* &
                        (1-exp(-(time/t0)**3))
                else
                   vx1(ix,iy,iz) = 0.0_num
                endif 
             END DO
          END DO
       END DO
       DO ix = -2, nx+2
          DO iy = -2, ny+2
             DO iz = -2,0
                r = sqrt(xb(ix)**2+yb(iy)**2)
                if (r .LE. r0) then
                   vy1(ix,iy,iz) = v0*(xb(ix)/r0)* &
                        (1.0_num-(r/r0)**2)*sin(omega*time)* &
                        (1-exp(-(time/t0)**3))
                else
                   vy1(ix,iy,iz) = 0.0_num
                endif          
             END DO
          END DO
       END DO
      vz1(:,:,-2:0) = 0.0_num
    END IF

    IF (proc_z_max == MPI_PROC_NULL .AND. zbc_max == BC_USER) THEN
      vx1(:,:,nz:nz+2) = 0.0_num
      vy1(:,:,nz:nz+2) = 0.0_num
      vz1(:,:,nz:nz+2) = 0.0_num
    END IF

  END SUBROUTINE remap_v_bcs



  !****************************************************************************
  ! Damped boundary conditions
  !****************************************************************************

  SUBROUTINE damp_boundaries

    REAL(num) :: a, d, r, rmax

    IF (.NOT.damping) RETURN

      d = 10.0_num
      DO iz = -1, nz + 1
        DO iy = -1, ny + 1
          DO ix = -1, nx + 1
            IF (zb(iz) > d) THEN
              a = dt * (zb(iz) - d) / (z_max - d) +1.0_num
              vx(ix,iy,iz) = vx(ix,iy,iz) / a
              vy(ix,iy,iz) = vy(ix,iy,iz) / a
              vz(ix,iy,iz) = vz(ix,iy,iz) / a
            END IF
          END DO
        END DO
      END DO

      rmax = 1.5_num
      DO iz = -1, nz + 1
        DO iy = -1, ny + 1
          DO ix = -1, nx + 1
            r = sqrt(xb(ix)**2+yb(iy)**2)
            IF (r > rmax) THEN
              a = dt * (r - rmax) / (x_max - rmax) +1.0_num
              vx(ix,iy,iz) = vx(ix,iy,iz) / a
              vy(ix,iy,iz) = vy(ix,iy,iz) / a
              vz(ix,iy,iz) = vz(ix,iy,iz) / a
            END IF
          END DO
        END DO
      END DO

    END SUBROUTINE damp_boundaries

END MODULE boundary

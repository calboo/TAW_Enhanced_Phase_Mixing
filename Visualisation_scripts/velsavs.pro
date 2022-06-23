pro velsavs, ds

;; DESCRIPTION

; IDL script used to produce sav files for the grid coordinates,
; cylindrical velocity components and density through the vertical
; midplane of a Lare3d output snapshot, ds.

; These sav files can then be loaded by other scripts
; that make use of the grid coordinates, cylindrical velocity
; components or density from Lare3d simulation outputs.

;; USAGE

; This script must be run in IDL, to run this script the user 
; must first load a snaphot from a Lare3d SDF output file. 

; It is only necessary to load the grid, velocities and density 
; to the snapshot. When running this script the snapshot, ds, must be
; given as an argument. The output sav files will be saved in a
; 'sav_files' directory.

;; SCRIPT

; Define the midpoint of the simulation, the cylindrical velocity
; components will be calculated over a plane through this midpoint
midpoint = 625

; Read the grid positions in x, y and z coordinates from the
; Lare3d output snapshot, ds
xgrid = ds.x
ygrid = ds.y
zgrid = ds.z

; Adjust the grid coordinates to align with the velocity components
; These are located at the cell vertices, not the cell centres
xgrid = xgrid-(xgrid[1]-xgrid[0])/2.0
x = [xgrid,[xgrid[-1]+(xgrid[1]-xgrid[0])]]
ygrid = ygrid-(ygrid[1]-ygrid[0])/2.0
y = [ygrid,[ygrid[-1]+(ygrid[1]-ygrid[0])]]
zgrid = zgrid-(zgrid[1]-zgrid[0])/2.0
z = [zgrid,[zgrid[-1]+(zgrid[1]-zgrid[0])]]

; Convert the grid coordinates into Mm
x = x*10.0
y = y*10.0
z = z*10.0

; Read the grid dimension in each direction
sx = size(x)
sy = size(y)
sz = size(z)
sx = sx[1]
sy = sy[1]
sz = sz[1]

; Read the velocity data from the Lare3d snapshot ds
vx = reform(ds.vx[midpoint,*,*])
vy = reform(ds.vy[midpoint,*,*])
vz = reform(ds.vz[midpoint,*,*])

; Set up array for the radius and the radial and azimuthal
; velocities across the vertical midplane
r = dblarr(sy,sz)
vr = dblarr(sy,sz)
vt = dblarr(sy,sz)

; Calculate the radius, vr and vt 
for i = 0,sy-1 do begin
   for j = 0,sz-1 do begin
      r[i,j] = abs(y[i])
      if (r[i,j] GT 1e-10) then begin
         vr[i,j] =  y[i]*vy[i,j]/r[i,j]
         vt[i,j] = -y[i]*vx[i,j]/r[i,j]
      endif else begin
         vr[i,j] = 0.0
         vt[i,j] = 0.0
      endelse
   endfor
endfor

; Read the density data from the Lare3d snapshot ds,
rho = reform(ds.rho[midpoint,*,*])

; Save grid coordinates to sav files
save, x, filename= 'sav_files/x.sav'
save, y, filename= 'sav_files/y.sav'
save, z, filename= 'sav_files/z.sav'

; Save the velocities to sav files
save, vt, filename= 'sav_files/vt.sav'
save, vr, filename= 'sav_files/vr.sav'
save, vz, filename= 'sav_files/vz.sav'

; Save the density to a sav file
save, rho, filename= 'sav_files/rho.sav'

end

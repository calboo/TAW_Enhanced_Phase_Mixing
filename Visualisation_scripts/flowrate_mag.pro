pro flowrate_mag

;; DESCRIPTION

; IDL script used to produce Figures 10 and 11 in the paper,
; Enhanced phase mixing of torsional Alfven waves in stratified and
; divergent solar coronal structures – Paper II. Non-linear simulations
; C.Boocock and D.Tsiklauri

; Produces a graph showing the total mass flow rate across
; magnetic surfaces against the height at which these magnetic
; surfaces intersect the vertical axis.

; The Lare3d output used is specified when running velsavs.pro,
; which produces sav files for the grid coordinates, cylindrical
; velocity components and density which are used by this script.

;; USAGE

; Before running this script the user must first run the IDL script
; velsavs.pro, which uses a Lare3d output snapshot to produce sav
; files for the grid coordinates and cylindrical velocity components
; and density across the vertical midplane of the simulation 

; This script must be run in IDL, the user must specify a valid filepaths
; within the script corresponding to the sav files for the grid
; coordinates, cylindrical velocity components and density.

; Figure 10 was produced by using this script and velsavs.pro with
; Lare3d outputs generated from the following parameters:
; H = 50 Mm, H_rho= 50 Mm, T = 60 s,
; u0 = 10 kms-1 and viscosity= 5 ×10^7 m2s−1.

; Figure 11 was produced by using this script and velsavs.pro with
; Lare3d outputs generated from the following parameters:
; H = 50 Mm, H_rho= 50 Mm, T = 60 s,
; u0 = 100 kms-1 and viscosity= 5 ×10^7 m2s−1.

;; SCRIPT

; Set normalisation constants for
; velocity and magnetic field

v0 = 692374 ; ms-1
b0 = 0.001 ; T

; Set scale height and tube radius in Mm

H = 50.0 ; Mm
r0 = 5.0 ; Mm

; Calculate psi at tube boundary

psib = r0*beselj(r0/H,1)

; Restore the grid coordinates from sav files
restore, 'sav_files/x.sav'
restore, 'sav_files/y.sav'
restore, 'sav_files/z.sav'

; Restore the velocities from sav files
restore, 'sav_files/vt.sav'
restore, 'sav_files/vr.sav'
restore, 'sav_files/vz.sav'

; Restore the density from a sav file
restore, 'sav_files/rho.sav'

; NB all lengths are in Mm

; Read the grid dimension in each direction
sx = size(x)
sy = size(y)
sz = size(z)
sx = sx[1]
sy = sy[1]
sz = sz[1]

; Normalise all velocities to ms-1
vt = vt*v0
vr = vr*v0
vz = vz*v0

; Make arrays for all variables
; across the vertical midplane

r = dblarr(sy,sz)
phi = dblarr(sy,sz)
psi = dblarr(sy,sz)
Br = dblarr(sy,sz)
Bz = dblarr(sy,sz)
rho_avgx = dblarr(sy-1,sz-1)
rho_avg = dblarr(sy-1,sz-1)
B =  dblarr(sy,sz)
vdotb = dblarr(sy,sz)
integrand = dblarr(sy,sz)

; Calculate the radius, phi, psi, Br and Bz

for i = 0,sy-1 do begin
   for j = 0,sz-1 do begin
      r[i,j] = abs(x[i])
      phi[i,j] = -H*exp(-z[j]/H)*beselj(r[i]/H,0)
      psi[i,j] = r[i]*exp(-z[j]/H)*beselj(r[i]/H,1)
      if (r[i,j] GT 1e-10) then begin
         Br[i,j] = b0*exp(-z[j]/H)*beselj(r[i,j]/H,1)
         Bz[i,j] = b0*exp(-z[j]/H)*beselj(r[i,j]/H,0)
      endif else begin
         Br[i,j] = 0.0
         Bz[i,j] = b0*exp(-z[j]/H)
      endelse
   endfor
endfor

; Calculate the density at cell vertices
; to align with the grid and velocity grids

for j = 1,sz-2 do begin
   for i = 1,sy-2 do begin
      rho_avgx[i-1,j-1] = (rho[i,j-1]+rho[i-1,j-1])/2.0
      rho_avg[i-1,j-1] = (rho_avgx[i-1,j]+rho_avgx[i-1,j-1])/2.0
   endfor
endfor

; Calculate the magnetic field strength
; and vdotb (actually v.B0/B)

for i = 0,sy-1 do begin
   for j = 0,sz-1 do begin
      B[i,j] = sqrt(Br[i,j]^2+Bz[i,j]^2)
      vdotb[i,j] = (vr[i,j]*Br[i,j]+vz[i,j]*Bz[i,j])/abs(B[i,j])
   endfor
endfor

; Calculate the integrand to be integrated with respect
; to psi from the centre to the tube boundary

for i = 1,sy-1 do begin
   for j = 1,sz-1 do begin
      integrand[i,j] = (2.0*!dpi*b0*H*rho[i-1,j-1])*vdotb[i,j]/B[i,j]
   endfor
endfor

; Plot a coloured contour of the integrand 

window, 1
contour, integrand, /fill, nlevels=100,XTITLE='r / Mm',YTITLE='z / Mm'

;;  Integrate across magnetic surfaces at each height 
;;  (also overplots paths for each integration)

  zscale = [] 
  flowrate = []
  z0 = -H*alog(beselj(r0/H,0))
  zlevels = sz

  for k= 0, zlevels-1 do begin
     z_en = 100.0*float(k)/float(zlevels)
     if (z_en LT z0) then begin 
        print, string(100.0*float(k)/float(zlevels),FORMAT='(f4.1)')+' %',' too low'
     endif else begin
        phi1 = -H*exp(-z_en/H)
        i = 625
        pointi =[]
        pointj =[]
        psi_int = []
        flow_int = []
        while (i LT sy) do begin
           p1 = value_locate(phi[i,*],phi1)
           p2 = p1+1
           if (p2 GT sz-1) then break
           psi_i = psi(i,p1)+(phi1-phi(i,p1))*(psi(i,p2)-psi(i,p1))/(phi(i,p2)-phi(i,p1))
           flow_i = integrand(i,p1)+(phi1-phi(i,p1))*(integrand(i,p2)-integrand(i,p1))/(phi(i,p2)-phi(i,p1))
           if (psi_i GE psib) then break
           pointi = [pointi, i]
           pointj = [pointj,p2]
           flow_int = [flow_int, flow_i]
           psi_int = [psi_int, psi_i]
           i = i+1 
        endwhile
        print, string(100*float(k)/float(zlevels),FORMAT='(f4.1)')+' %'
        oplot, pointi, pointj
        en1 = int_tabulated(psi_int,flow_int)
        zscale = [zscale, z_en]
        flowrate = [flowrate, en1]
     endelse
  endfor 

; Convert flowrate to kgs-1

; Convert rho to kgm-3 by multiplying through rho0 [x1.66x10^-12]
; Convert H to m [x10^6]
; Convert dpsi to m [x10^6]
; Overall conversion is [x1.66]

flowrate = flowrate*1.66 

; Plot the mass flow rate with height

w1 = window(DIMENSIONS=[1000,700])
p1 = plot(zscale, flowrate, THICK=2,$
          XTITLE= 'Height / Mm', YTITLE= 'Mass Flow Rate / kgs!E-1',$
          FONT_SIZE=20,/CURRENT)

; Save the plot to a png file

p1.Save, "mass_flow.png"

end

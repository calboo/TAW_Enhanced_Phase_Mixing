pro vplot_lare

;; DESCRIPTION

; IDL script used to produce Figure 4 in the paper,
; Enhanced phase mixing of torsional Alfven waves in stratified and
; divergent solar coronal structures – Paper II. Non-linear simulations
; C.Boocock and D.Tsiklauri

; Produces a graph of the azimuthal velocity against the radius, r,
; and height, z, for a Lare3d output. Note that the damping regions
; in the domain are not plotted.

; The Lare3d output used is specified when running velsavs.pro,
; which produces sav files for the grid coordinates and cylindrical
; velocity components that are used by this script. 

;; USAGE

; Before running this script the user must first run the IDL script
; velsavs.pro, which uses a Lare3d output snapshot to produce sav
; files for the grid coordinates and cylindrical velocity components. 

; This script must be run in IDL, the user must specify a valid filepaths
; within the script corresponding to the sav files for the grid
; coordinates and cylindrical velocity components.

; The contour levels will need to be adjusted depending
; on the parameters being considered.

; Figure 4 was produced by using this script and velsavs.pro with
; Lare3d outputs generated from the following parameters:
; H = 50 Mm, H_rho= 50 Mm, T = 60 s,
; u0 = 100 kms-1 and viscosity= 5 ×10^7 m2s−1.

;; SCRIPT

; Restore the grid coordinates from sav files
restore, 'sav_files/x.sav'
restore, 'sav_files/y.sav'
restore, 'sav_files/z.sav'

; Restore the velocities from sav files
restore, 'sav_files/vt.sav'
restore, 'sav_files/vr.sav'
restore, 'sav_files/vz.sav'

; Plot a coloured contour of the azimuthal velocity
; Note that the damping regions in the domain are not plotted

w1 = WINDOW(DIMENSIONS=[800,800])
ct = colortable(3)
clevels = 100.0*(findgen(101)/50-1.0)
c1 = CONTOUR(vt[125:1125,0:2000]*692.374,y[125:1125],z[0:2000], SHADING=1,$
             /FILL, RGB_TABLE=ct,XTITLE='r / Mm',YTITLE='z / Mm',$
             XSTYLE=1,YSTYLE=1,/CURRENT,$
             POSITION=[0.12,0.25,0.95,0.95],FONT_SIZE=20,C_VALUE=clevels)
cb = COLORBAR(TARGET=c3,TITLE='Velocity / kms!E-1',$
              POSITION=[0.05,0.14,0.95,0.16],FONT_SIZE=20)

; Save image as a png file

c1.save, "vplot_lare.png"

end

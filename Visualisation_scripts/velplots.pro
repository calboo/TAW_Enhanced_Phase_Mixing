pro velplots

;; DESCRIPTION

; IDL script used to produce Figures 5 and 6 in the paper,
; Enhanced phase mixing of torsional Alfven waves in stratified and
; divergent solar coronal structures – Paper II. Non-linear simulations
; C.Boocock and D.Tsiklauri

; Produces a panel plot showing the azimuthal, radial and vertical 
; plasma velocities across the vertical midplane of a Lare3d
; simulation output. Note that the damping regions in the domain
; are not plotted.

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

; The contour levels and colour bar tick labels will need to be
; adjusted depending on the parameters being considered.

; Figure 5 was produced by using this script and velsavs.pro with
; Lare3d outputs generated from the following parameters:
; H = 50 Mm, H_rho= 50 Mm, T = 60 s,
; u0 = 100 kms-1 and viscosity= 5 ×10^7 m2s−1.

; Figure 6 was produced by using this script and velsavs.pro with
; Lare3d outputs generated from the following parameters:
; H = 50 Mm, H_rho= 50 Mm, T = 60 s,
; u0 = 10 kms-1 and viscosity= 5 ×10^7 m2s−1.

;; SCRIPT

; Restore the grid coordinates from sav files
restore, 'sav_files/x.sav'
restore, 'sav_files/y.sav'
restore, 'sav_files/z.sav'

; Restore the velocities from sav files
restore, 'sav_files/vt.sav'
restore, 'sav_files/vr.sav'
restore, 'sav_files/vz.sav'

; Set up the window and colour table

w1 = WINDOW(DIMENSIONS=[1800,600])
ct = colortable(3)

; Plot the first contour plot of the azimuthal velocity

clevels = 100.0*(findgen(101)/50-1.0)
c1 = CONTOUR(vt[125:1125,0:2000]*692.374,y[125:1125],z[0:2000], SHADING=1,$
             /FILL, RGB_TABLE=ct,XTITLE='x / Mm',YTITLE='z / Mm',$
             XSTYLE=1,YSTYLE=1,/CURRENT,$
             POSITION=[0.07,0.27,0.35,0.97],FONT_SIZE=20,C_VALUE=clevels)
cb = COLORBAR(TARGET=c1,TITLE='v!D$\theta$!N / kms!U-1',$
              POSITION=[0.07,0.14,0.34,0.16],FONT_SIZE=20,$
              TICKNAME=['-100','-50','0','50','100'])

; Plot the second contour plot of the radial velocity

clevels = 2.5*(findgen(101)/50-1.0)
c2 = CONTOUR(vr[125:1125,0:2000]*692.374,y[125:1125],z[0:2000], SHADING=1,$
             /FILL, RGB_TABLE=ct,XTITLE='x / Mm',$
             XSTYLE=1,YSTYLE=1,/CURRENT,$
             POSITION=[0.39,0.27,0.67,0.97],FONT_SIZE=20,C_VALUE=clevels)
cb = COLORBAR(TARGET=c2,TITLE='v!Dr!N / kms!U-1',$
              POSITION=[0.39,0.14,0.66,0.16],FONT_SIZE=20,$
              TICKNAME=['-2.50','-1.25','0.00','1.25','2.50'])

; Plot the second contour plot of the vertical velocity

clevels = 30.0*(findgen(101)/50-1.0)
c3 = CONTOUR(vz[125:1125,0:2000]*692.374,y[125:1125],z[0:2000], SHADING=1,$
             /FILL, RGB_TABLE=ct,XTITLE='x / Mm',$
             XSTYLE=1,YSTYLE=1,/CURRENT,$
             POSITION=[0.71,0.27,0.99,0.97],FONT_SIZE=20,C_VALUE=clevels)
cb = COLORBAR(TARGET=c3,TITLE='v!Dz!N / kms!U-1',$
              POSITION=[0.71,0.14,0.98,0.16],FONT_SIZE=20,$
              TICKNAME=['-30','-15','0','15','30'])

; Save the panel plot to a png file
c1.save, "Panel_high.png"

end

pro rho_graphs, ds, ds0

;; DESCRIPTION

; IDL script used to produce Figures 8 and 9 in the paper,
; Enhanced phase mixing of torsional Alfven waves in stratified and
; divergent solar coronal structures – Paper II. Non-linear simulations
; C.Boocock and D.Tsiklauri

; Produces four images, two shaded surface plots showing the initial
; and final density profiles across the vertical midplane of a Lare3d
; simulation, and two images showing coloured contours of the 
; the initial and final density profiles across the vertical midplane
; of a Lare3d simulation. Note that the damping regions in the domain
; are not plotted.

;; USAGE

; This script must be run in IDL, to run this script the user 
; must first load two snaphots from Lare3d SDF output files.
; The first snapshot, ds0, should correspond to the initial
; Lare3d simulation output and the second, ds should correspond
; to the final Lare3d simulation output. 

; It is only necessary to load the grid and density to the snapshots.
; When running this script the snapshots, ds0 and ds, must be given
; as arguments.

; The contour levels will need to be adjusted depending
; on the parameters being considered.

; Figures 8 and 9 was produced by using this script with Lare3d
; outputs generated from the following parameters:
; H = 50 Mm, H_rho= 50 Mm, T = 60 s,
; u0 = 100 kms-1 and viscosity= 5 ×10^7 m2s−1.

;; SCRIPT

; Define the midpoint of the simulation
midpoint = 625

; Read the grid positions in x, y and z coordinates from the
; Lare3d output snapshot, ds
xgrid = ds.x
ygrid = ds.y
zgrid = ds.z

; Convert the grid coordinates into Mm
x = x*10.0
y = y*10.0
z = z*10.0

; Define densities as those across the vertical midplanes
; of the simulation at initial and final times

rho0 = reform(ds0.rho[midpoint,*,*])
rho = reform(ds.rho[midpoint,*,*])

; Set up the background colours for the shade_surf plots

TVLCT, 255, 255, 255, 254 ; White color
TVLCT, 0, 0, 0, 253       ; Black color
!P.Color = 253
!P.Background = 254

; Set up character of Greek rho
rholetter = '!4'+String("161B)+'!X'
;; This line is to correct code colouring "

; Plot shaded surface plot for the initial density
; across the vertical midplane of the simulation

window, 1
shade_surf, reform(rho0[125:1125,0:2000],y[125:1125],z[0:2000],$
            CHARSIZE=4, XSTYLE=1, CHARTHICK=1, ax=40, az=30,$
            XTITLE='X / Mm', YTITLE='Z / Mm', ZTITLE='Density /'+rholetter+'!D0',$
            POSITION=[0.2,0.2,0.95,0.95]  

; Save the shaded surface plot to a png file

WRITE_PNG, 'density_ini.png', TVRD(/TRUE)

; Plot shaded surface plot for the final density
; across the vertical midplane of the simulation

window, 2
shade_surf, reform(rho[125:1125,0:2000]),y[125:1125],z[25:2000],$
            CHARSIZE=4, XSTYLE=1, CHARTHICK=1, ax=40, az=30,$
            XTITLE='X / Mm', YTITLE='Z / Mm', ZTITLE='Density /'+rholetter+'!D0',$
            POSITION=[0.2,0.2,0.95,0.95]

; Save the shaded surface plot to a png file

WRITE_PNG, 'density_end.png', TVRD(/TRUE)

; Plot a coloured contour for the initial density
; across the vertical midplane of the simulation

w1 = WINDOW(DIMENSIONS=[800,800])
ct = colortable(3)
clevels = 1.0*findgen(101)/100
c1 = CONTOUR(rho0[125:1125,0:2000],y[125:1125],z[0:2000], SHADING=1,$
             /FILL, RGB_TABLE=ct,XTITLE='x / Mm',YTITLE='z / Mm',$
             XSTYLE=1,YSTYLE=1,/CURRENT,$
             POSITION=[0.12,0.25,0.95,0.95],FONT_SIZE=20,C_VALUE=clevels)
cb = COLORBAR(TARGET=c5,TITLE='Density / $\rho$!D0',$
              POSITION=[0.05,0.14,0.95,0.16],FONT_SIZE=20)

; Plot a coloured contour for the final density
; across the vertical midplane of the simulation

w2 = WINDOW(DIMENSIONS=[800,800])
ct = colortable(3)
clevels = 1.0*findgen(101)/100
c2 = CONTOUR(rho[125:1125,0:2000],y[125:1125],z[0:2000], SHADING=1,$
             /FILL, RGB_TABLE=ct,XTITLE='x / Mm',YTITLE='z / Mm',$
             XSTYLE=1,YSTYLE=1,/CURRENT,$
             POSITION=[0.12,0.25,0.95,0.95],FONT_SIZE=20,C_VALUE=clevels)
cb = COLORBAR(TARGET=c4,TITLE='Density / $\rho$!D0',$
              POSITION=[0.05,0.14,0.95,0.16],FONT_SIZE=20)

; Save the coloured contour plots as png files

c1.save, "ini_density.png"
c2.save, "end_density.png"

end

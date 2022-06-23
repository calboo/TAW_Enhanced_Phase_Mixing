pro loggraph

;; DESCRIPTION

; IDL script used to produce Figure 7 in the paper,
; Enhanced phase mixing of torsional Alfven waves in stratified and
; divergent solar coronal structures – Paper II. Non-linear simulations
; C.Boocock and D.Tsiklauri

; Produces a graph showing the dependence of the maximum 
; amplitudes in radial and vertical velocities on the amplitude
; of the driving amplitude as characterised by the parameter u0.

; The graph uses logarithmic x and y axis, has lines of best fit
; for vr and vz, has markers for each data point and also has a
; line showing a quadratic dependence for comparison.

;; USAGE

; Before running this script the user must first run the IDL script
; velsavs.pro in three directories containing the output data from
; Lare3d simulations using low, medium and high driving amplitudes of
; 1, 10 and 100 kms-1. 

; This will generate sav files for the grid coordinates and
; cylindrical  velocity components for each simulation which are
; required as inputs for this script to run.

; This script must be run in IDL, the user must specify a valid filepaths
; within the script corresponding to the sav files for the grid
; coordinates and cylindrical velocity components of each simulation.

; Figure 7 was produced by using this script and velsavs.pro with
; Lare3d outputs generated from the following parameters:
; H = 50 Mm, H_rho= 50 Mm, T = 60 s and viscosity= 5 ×10^7 m2s−1,
; and with wave driving amplitudes of u0 = 1, 10 and 100 kms-1.

;; SCRIPT

; The velocity normalisation required
; to convert to kms-1

v0 = 692.374 ; kms-1

; Create an array to store the maximum values 
; of vt, vr and vz from each simulation

vts = dblarr(3)
vrs = dblarr(3)
vzs = dblarr(3)

;; High amp

; Load the cylindrical velocity component data
; from high amplitude Lare3d run directory

restore, '../highamp/sav_files/vt.sav'
restore, '../highamp/sav_files/vr.sav'
restore, '../highamp/sav_files/vz.sav'

; print the maximum values of
; vt, vr and vz in kms-1

print, abs(max(vt))*v0
print, abs(max(vr))*v0
print, abs(max(vz))*v0

; Store the maximum values of
; vt, vr and vz in arrays

vts[2] = abs(max(vt))*v0
vrs[2] = abs(max(vr))*v0
vzs[2] = abs(max(vz))*v0

;; Medium amp

; Load the cylindrical velocity component data
; from medium amplitude Lare3d run directory

restore, '../medamp/sav_files/vt.sav'
restore, '../medamp/sav_files/vr.sav'
restore, '../medamp/sav_files/vz.sav'

; print the maximum values of
; vt, vr and vz in kms-1

print, abs(max(vt))*v0
print, abs(max(vr))*v0
print, abs(max(vz))*v0

; Store the maximum values of
; vt, vr and vz in arrays

vts[1] = abs(max(vt))*v0
vrs[1] = abs(max(vr))*v0
vzs[1] = abs(max(vz))*v0

;; Low amp

; Load the cylindrical velocity component data
; from low amplitude Lare3d run directory

restore, '../lowamp/sav_files/vt.sav'
restore, '../lowamp/sav_files/vr.sav'
restore, '../lowamp/sav_files/vz.sav'

; print the maximum values of
; vt, vr and vz in kms-1

print, abs(max(vt))*v0
print, abs(max(vr))*v0
print, abs(max(vz))*v0

; Store the maximum values of
; vt, vr and vz in arrays

vts[0] = abs(max(vt))*v0
vrs[0] = abs(max(vr))*v0
vzs[0] = abs(max(vz))*v0

; Create an array of the parameter u0 that defines
; wave driving amplitude in each simulation

drive = [1d0,10d0,100d0]

; Plot a line graph of the maximum radial velocities agaist wave
; driving on log-log axis, including filled diamond symbols at each
; data point.

p1 = plot(drive, vrs, THICK=2, LINESTYLE=2, $
          XTITLE= 'Driving Amplitude / kms!E-1',$
          YTITLE= 'Maximum Amplitude / kms!E-1', YLOG=1,XLOG=1,$
          FONT_SIZE=15, YRANGE=[1e-4,1e2], XRANGE=[5e-1,2e2],$
          SYM_FILLED=1, SYMBOL='D', $
          YTICKNAME=['10!U-4','10!U-3','10!U-2','10!U-1','10!U0','10!U1','10!U2'])

; Overplot a line graph of the maximum vertical velocities agaist wave,
; including filledempty triangle symbols at each data point.

p2 = plot(drive, vzs, THICK=2, LINESTYLE=4, SYMBOL='tu',SYM_FILLED=0,/overplot)

; Overplot a line showing a quadratic dependence on wave driving as a
; visual aid.

p3 = plot(drive, y, THICK=2, LINESTYLE=0,/overplot)

; Add labels for the lines showing the variation of vr and vz

t1 = TEXT(20,2,'v!Dz', /DATA, FONT_SIZE=14, FONT_STYLE='Italic')
t2 = TEXT(20,0.2,'v!Dr', /DATA, FONT_SIZE=14, FONT_STYLE='Italic')

; Save the image as a png file

p1.Save, "loglog.png"

end

# TAW Enhanced Phase Mixing

To simulate the propagation and enhanced phase mixing of Torsional Alfv&egrave;n Waves (TAWs) the MHD simulation code Lare3d was used. The Lare3d code, manual and IDL visualisation scripts can be found here:  https://warwick.ac.uk/fac/sci/physics/research/cfsa/people/tda/larexd/.

The equilibrium setup is a potential magnetic field with an expanding field line structure whose magnetic field strength decays with height. The field is axisymmetric and has no azimuthal component. This field is embedded in a exponentially stratified density structure with a higher density expanding tube structure that aligns with magnetic field and has a transverse density gradient across the magnetic field lines. The plasma beta is assumed to be negligible. Throughout the simulation TAWs are driven from the lower boundary of the domain and propagate upwardly.

The Lare3d source files, included here, have been edited to include uniform viscous damping as an incompressible term in the momentum equation, and to include two additional simulation outputs corresponding to the wave envelopes for the velocity and magnetic field perturbations. The uniform viscosity term was used in utilised in the simulations. It was, however, not possible to utilise the wave envelope outputs in the simulation analysis due to the presence of nonlinear effects. The Lare3d simulations and the simulation results are described in the paper:

*Enhanced phase mixing of torsional Alfvén waves in stratified and divergent solar coronal structures – II. Non-linear simulations*, https://academic.oup.com/mnras/article-abstract/510/2/2618/6460507?redirectedFrom=fulltext

This paper compares the nonlinear Lare3d simulation outputs to the outputs from Wigglewave which calculates the solutions to the linearised governing equation for the propagation and enhanced phase mixing of TAWs. The Lare3d outputs are further analysed to identify nonlinearly generated magnetosonic waves and shock waves, and to calculate the net mass flow caused by these compressive perturbations.

This repository contains all the files needed to reproduce the simulations described and the figures shown in this paper. 

## Simulation files

The folder Lare3d_source_files contains seven source files to be used within Lare3d:

- control.f90
- initial_conditions.f90
- boundary.f90
- diagnostics.F90
- shared_data.F90
- lagran.F90
- mpi_routines.F90

To utilise these files in Lare3d the first four should replace files of the same name in the *src* directory and the final three should replace files of the same name in the *core* subdirectory which is found within the *src* directory. Information on how to run Lare3d is given in the Lare3d manual which can be accessed from the webpage https://warwick.ac.uk/fac/sci/physics/research/cfsa/people/tda/larexd/.

## Simulation Parameters

The simulation parameters can be changed in a few different places:

In **control.f90** the normalisation constants for length (L_norm),  magnetic field strength (B_norm) and density (rho_norm) can be set. The number of grid cells in each direction, the domain size in each direction, the simulation end time and the time between each output dump can also be set here. In combination these can be used to set the spatial and temporal resolution of the outputs. Other important simulation parameters can also be set here although it is recommended that the other parameters in *control.f90* be left as the are.

In **initial_conditions.f90** the user can set *visc3* at the end of the initial conditions. This parameter sets the a constant uniform viscosity across the domain. It should be noted that *visc3* is given in normalised units. The normalisation for visocity nu_norm = v_norm * L_norm.

In **boundary.f90** the user can set the height and radius within the domain, beyond which exponential boundary damping is applied. This will be particularly relevant if the domain dimensions are changed.

In **shared_data.f90** the user can set the majority of the simulation parmaeters. These can be found under a the section of code labelled *Parameters for TAW Enhanced Phase Mixing*. The simulation parameters that can be set here are:

| Parameter | Description |
| --- | --- |
| H | The magnetic scale height |
| b0 | The strength of the background magnetic field |
| rho_alpha | The ratio of magnetic and density scale heights, rho_alpha = H/H_rho|
| zeta | The density contrast of the central high density flux tube |
| period | The wave period of the TAW driving |
| omega | The frequency of TAW driving |
| v0 | The amplitude of TAW driving, in normalised velocity units |
| r0 | The radius of the central high density flux tube|
| t0 | The rampup time of TAW driving|

## Visualisation scripts

The IDL visulasation scripts that used TAWAS outputs to generate figures for the paper, *Enhanced phase mixing of torsional Alfvén waves in stratified and divergent solar coronal structures – II. Non-linear simulations*, can be found in under Visualisation_scripts. The purpose of each script is as follows:

| Script | Description |
| --- | --- |
| velsavs.pro | Used to produce sav files from a specified Lare3d output that can be utilised by other visulaisation scripts. The sav files produced are for the numerical grids, the azimuthal, radial and vertical velocities and the density over a vertical midplane of the simulation output. |
| vplot_lare.pro | Produces a graph of the azimuthal velocity against the radius, r, and height, z, for a Lare3d output using sav files generated with velsavs.pro, used to produce Figure 4 in the paper.|


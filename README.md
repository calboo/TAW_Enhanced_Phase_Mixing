# TAW Enhanced Phase Mixing

To simulate the propagation and enhanced phase mixing of Torsional Alfv&egrave;n Waves (TAWs) the MHD simulation code Lare3d was used. The Lare3d code, manual and IDL visualisation scripts can be found here:  https://warwick.ac.uk/fac/sci/physics/research/cfsa/people/tda/larexd/.

The equilibrium setup is a potential magnetic field with an expanding field line structure whose magnetic field strength decays with height. The field is axisymmetric and has no azimuthal component. This field is embedded in a exponentially stratified density structure with a higher density expanding tube structure that aligns with magnetic field and has a transverse density gradient across the magnetic field lines. The plasma beta is assumed to be negligible. Throughout the simulation TAWs are driven from the lower boundary of the domain and propagate upwardly.

The Lare3d source files, included here, have been edited to include a uniform viscous damping as a term in the momentum equation and to include two additional simulation outputs corresponding to the wave envelopes for the velocity and magnetic field perturbations. The uniform viscosity term was used in utilised in the simulations. It was, however, not possible to utilise the wave envelope outputs in the simulation analysis due to the presence of nonlinear effects. The Lare3d simulations and the simulation results are described in the paper:

*Enhanced phase mixing of torsional Alfvén waves in stratified and divergent solar coronal structures – II. Non-linear simulations*, https://academic.oup.com/mnras/article-abstract/510/2/2618/6460507?redirectedFrom=fulltext

This paper compares the nonlinear Lare3d simulation outputs to the outputs from Wigglewave which calculates the solutions to the linearised governing equation for the propagation and enhanced phase mixing of TAWs. The Lare3d outputs are further analysed to identify nonlinearly generated Magnetosonic waves and shock wave, and to calculate the net mass flow caused by these compressive perturbations.

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

### Source file modifications

Modifications to the Lare3d source files provided here are as follows:

| Script | Modification |
| --- | --- |
| **control.f90** | The blah blah blah blah blah |
| **initial_conditions.f90** | The blah blah blah blah blah |
| **boundary.f90** | The blah blah blah blah blah |
| **diagnostics.F90** | The blah blah blah blah blah |
| **shared_data.F90** | The blah blah blah blah blah |
| **lagran.F90** | The blah blah blah blah blah |
| **mpi_routines.F90** | The blah blah blah blah blah |

### Simulation Inputs

## Visualisation scripts


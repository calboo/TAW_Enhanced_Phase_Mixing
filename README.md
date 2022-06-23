# TAW Enhanced Phase Mixing

To simulate the propagation and enhanced phase mixing of Torsional Alfv&egrave;n Waves (TAWs) the MHD simulation code Lare3d was used. The Lare3d code, manual and IDL visualisation scripts can be found here:  https://warwick.ac.uk/fac/sci/physics/research/cfsa/people/tda/larexd/.

The equilibrium setup is a potential magnetic field with an expanding field line structure whose magnetic field strength decays with height. The field is axisymmetric and has no azimuthal component. This field is embedded in a exponentially stratified density structure with a higher density expanding tube structure that aligns with magnetic field and has a transverse density gradient across the magnetic field lines. The plasma beta is assumed to be negligible. Throughout the simulation TAWs are driven from the lower boundary of the domain and propagate upwardly.

The Lare3d source files, included here, have been edited to include a uniform viscous damping as a term in the momentum equation and to include two additional simulation outputs corresponding to the wave envelopes for the velocity and magnetic field perturbations. The Lare3d simulations and the simulation results are described in the paper:

*Enhanced phase mixing of torsional Alfvén waves in stratified and divergent solar coronal structures – II. Non-linear simulations*, https://academic.oup.com/mnras/article-abstract/510/2/2618/6460507?redirectedFrom=fulltext

This paper compares the nonlinear Lare3d simulation outputs to the outputs from Wigglewave which calculates the solutions to the linearised governing equation for the propagation and enhanced phase mixing of TAWs. The Lare3d outputs are further analysed to identify nonlinearly generated Magnetosonic waves and shock wave, and to calculate the net mass flow caused by these compressive perturbations.

This repository contains all the files needed to reproduce the simulations described and the figures shown in this paper. 



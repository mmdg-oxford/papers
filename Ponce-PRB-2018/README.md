<p align="center">
  <img src="https://github.com/mmdg-oxford/papers/blob/master/Ponce-PRB-2018/Paper/fig3.png" width="400" />
</p>


# [Towards predictive many-body calculations of phonon-limited carrier mobilities in semiconductors](https://journals.aps.org/prb/abstract/10.1103/PhysRevB.97.121201)
<p align="right">
by S. Poncé, E.R. Margine and F. Giustino
</p>

---

The structure of this additional documentation is as follow:
## BS-exp
Contains the data to compute the Si bandstructure
of B-doped diamond
+ PW input files

Allow to reproduce in part Fig. 2 

## effective_mass_SOC_GW
Contains data to compute the effective masses with SOC and GW corrections
+ PW input files
+ EPW input files

Allow to reproduce Table S1 in part. 

## meshes
Contains the Sobol and Cauchy grids used for the mobility calculations

## mobility_SOC_85k_GW_YAM
Contains the data to compute the carrier mobility with SOC and GW corrections
+ PW input files 
+ EPW input files 

Allow to reproduce in part Fig. 3 of the paper. 

## Paper
TeX file of the paper
+ All .pdf or .png figues
+ .bib file
+ .pdf of the paper

## phonons
Contains the data to compute the phonon BS and electron-phonon matrix element on the coarse grid
+ PW input files
+ PH input file

## pp
Contains the various PSP that have been tested for this paper

## thermo_pw
Contains the input files for the thermo_pw code. 

Allow to reproduce in part Fig. S4 and S5



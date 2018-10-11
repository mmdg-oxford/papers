#!/bin/bash
#SBATCH --qos=prace
#SBATCH --time=1-20:00:00
#SBATCH --nodes=96
#SBATCH --ntasks=768
#SBATCH --ntasks-per-node=8
#SBATCH --job-name=ssGW4

module load intel/2017.4
module load impi/2017.4
module load mkl/2017.4
module load bsc/1.0
module load hdf5/1.8.19
module load  netcdf/4.4.1.1 
module load fftw/3.3.6


yambo=/home/pr1eeh00/pr1eeh01/program/yambo-4.2.0/bin/yambo
ypp=/home/pr1eeh00/pr1eeh01/program/yambo-4.2.0/bin/ypp

# final step
mpirun -np $SLURM_NTASKS $yambo -F ssGW_kdep_final4.in -J ssGW_kdep_final4

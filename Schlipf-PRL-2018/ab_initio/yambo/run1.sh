#!/bin/bash
#SBATCH --job-name=MAPI
#SBATCH --qos=prace
#SBATCH --time=2-12:00:00
#SBATCH --nodes=8
#SBATCH --ntasks=192
#SBATCH --cpus-per-task=2

## Set up job environment:
#module purge   # clear any inherited modules

module load intel/2017.4
module load impi/2017.4
module load mkl/2017.4
module load bsc/1.0

pw=/home/pr1eeh00/pr1eeh01/program/qe-6.0/bin/pw.x

mpirun -np 96 $pw < scf.in > scf.out
mpirun -np 192 $pw -ndiag 4 < nscf.in > nscf.out

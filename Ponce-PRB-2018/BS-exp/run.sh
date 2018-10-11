#!/bin/bash
#SBATCH --job-name=si-band
#SBATCH --qos=prace
#SBATCH --time=0-05:00:00
#SBATCH --error=job.err
#SBATCH --output=job.out
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --cpus-per-task=1

## Set up job environment:
#module purge   # clear any inherited modules

module load intel/2017.4
module load impi/2017.4
module load mkl/2017.4
module load bsc/1.0
module load fftw/3.3.6

mpirun -np 24 /home/pr1eeh00/pr1eeh01/program/q-e-June2018/bin/pw.x     < scf.in > scf.out
mpirun -np 24 /home/pr1eeh00/pr1eeh01/program/q-e-June2018/bin/pw.x     < bands.in > bands.out
mpirun -np 24 /home/pr1eeh00/pr1eeh01/program/q-e-June2018/bin/bands.x  < pp.in > pp.out


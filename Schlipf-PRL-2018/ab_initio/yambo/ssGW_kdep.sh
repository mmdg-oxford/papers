#!/bin/bash
#SBATCH --qos=prace
#SBATCH --time=3-00:00:00
#SBATCH --nodes=128
#SBATCH --ntasks=768
#SBATCH --ntasks-per-node=6
#SBATCH --job-name=ssGW_kdep

module load intel/2017.4
module load impi/2017.4
module load mkl/2017.4
module load bsc/1.0
module load hdf5/1.8.19
module load netcdf/4.4.1.1 
module load fftw/3.3.6


yambo=/home/pr1eeh00/pr1eeh01/program/yambo-4.2.0/bin/yambo
ypp=/home/pr1eeh00/pr1eeh01/program/yambo-4.2.0/bin/ypp

# step 0
#mpirun -np $SLURM_NTASKS $yambo -F ssGW_kdep.in -J ssGW_kdep0
#$ypp -q g -J ssGW_kdep0 -F ssGW_kdep0.in -Q
#sed -i -e 's/|232|232|/|   1| 232|/g' ssGW_kdep0.in
#sed -i -e 's/|233|233|/| 233|1000|/g' ssGW_kdep0.in
#$ypp -J . -F ssGW_kdep0.in
# step 1
mpirun -np $SLURM_NTASKS $yambo -F ssGW_kdep.in -J ssGW_kdep1
$ypp -q g -J ssGW_kdep1 -F ssGW_kdep1.in -Q
sed -i -e 's/|232|232|/|   1| 232|/g' ssGW_kdep1.in
sed -i -e 's/|233|233|/| 233|1000|/g' ssGW_kdep1.in
$ypp -J . -F ssGW_kdep1.in
# step 2
mpirun -np $SLURM_NTASKS $yambo -F ssGW_kdep.in -J ssGW_kdep2
$ypp -q g -J ssGW_kdep2 -F ssGW_kdep2.in -Q
sed -i -e 's/|232|232|/|   1| 232|/g' ssGW_kdep2.in
sed -i -e 's/|233|233|/| 233|1000|/g' ssGW_kdep2.in
$ypp -J . -F ssGW_kdep2.in
# step 3
mpirun -np $SLURM_NTASKS $yambo -F ssGW_kdep.in -J ssGW_kdep3
$ypp -q g -J ssGW_kdep3 -F ssGW_kdep3.in -Q
sed -i -e 's/|232|232|/|   1| 232|/g' ssGW_kdep3.in
sed -i -e 's/|233|233|/| 233|1000|/g' ssGW_kdep3.in
$ypp -J . -F ssGW_kdep3.in
# step 4
mpirun -np $SLURM_NTASKS $yambo -F ssGW_kdep.in -J ssGW_kdep4
$ypp -q g -J ssGW_kdep4 -F ssGW_kdep4.in -Q
sed -i -e 's/|232|232|/|   1| 232|/g' ssGW_kdep4.in
sed -i -e 's/|233|233|/| 233|1000|/g' ssGW_kdep4.in
$ypp -J . -F ssGW_kdep4.in
# final step
mpirun -np $SLURM_NTASKS $yambo -F ssGW_kdep_final.in -J ssGW_kdep_final

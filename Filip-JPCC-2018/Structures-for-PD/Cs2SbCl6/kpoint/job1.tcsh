#!/bin/bash
#PBS -l nodes=3:ppn=16
#PBS -l walltime=120:00:00
#PBS -N cs2sbcl6
#PBS -m bae
#PBS -M xinlei.liu@seh.ox.ac.uk


module load espresso/5.3.0

# develq - short queue with walltime 10 minutes and maximum 2 nodes
# to submit to develq: qsub -q develq script.pbs

# Set up mpi on ARCUS
. enable_arcus_mpi.sh


# Executable aliases
export MPI_GROUP_MAX=64


# Copy to TMPDIR all files required for start
cd $PBS_O_WORKDIR


foreach NLINE ( `seq 1 15` )
cp cs2sbcl6-scf.in cs2sbcl6-scf-${NLINE}.in
head -${NLINE} cs2sbcl61_kp.txt | tail -1 >> cs2sbcl6-scf-${NLINE}.in
$MPIRUN -np $NSLOTS $PW < cs2sbcl6-scf-${NLINE}.in > cs2sbcl6-scf-${NLINE}.out
end

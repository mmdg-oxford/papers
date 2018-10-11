#!/bin/tcsh
#$ -l qname=parallel.q
#$ -l h_rt=24:00:00
#$ -N cs2cucl4
#$ -o jobtest.out
#$ -e jobtest.err
#$ -cwd
#$ -pe orte 72
#$ -j y
#$ -R y
#$ -l h_vmem=2.875G
#$ -V



module purge
module load  fft/fftw-3.3.4_intel15
module load  mpi/openmpi-1.10.2_intel15
module load  intel/ics-2015-3-187



set MPIRUN = "/share/apps/mpi/openmpi-1.10.2/bin/mpirun --mca btl self,openib,sm,tcp"
set PW = /home/ted/codes/espresso-5.4.0/bin/pw.x
set NSLOTS = 72



foreach NLINE ( `seq 1 15` )
cp cs2cucl4-scf.in cs2cucl4-scf-${NLINE}.in
head -${NLINE} cs2cucl41_kp.txt | tail -1 >> cs2cucl4-scf-${NLINE}.in
$MPIRUN -np $NSLOTS $PW < cs2cucl4-scf-${NLINE}.in > cs2cucl4-scf-${NLINE}.out
end

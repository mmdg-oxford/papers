#!/bin/tcsh
#$ -l qname=parallel.q
#$ -l h_rt=24:00:00
#$ -N bi6br7
#$ -o jobtest.out
#$ -e jobtest.err
#$ -cwd
#$ -pe orte 144
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
set NSLOTS = 144



foreach NLINE ( `seq 2 20` )
cp bi6br7-scf.in bi6br7-scf-${NLINE}.in
head -${NLINE} bi6br71_kp.txt | tail -1 >> bi6br7-scf-${NLINE}.in
$MPIRUN -np $NSLOTS $PW < bi6br7-scf-${NLINE}.in > bi6br7-scf-${NLINE}.out
end

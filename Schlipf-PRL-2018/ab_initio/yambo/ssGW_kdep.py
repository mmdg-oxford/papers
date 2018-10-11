from __future__ import print_function
from yambopy import *

lower_vb = 1
upper_vb = 232
final_vb = 161
lower_cb = upper_vb + 1
upper_cb = 1000
final_cb = 256
jobname='ssGW_kdep'
yambo_exe = '/home/pr1eeh00/pr1eeh01/program/yambo-4.2.0/bin/yambo'
ypp_exe = '/home/pr1eeh00/pr1eeh01/program/yambo-4.2.0/bin/ypp'

yambo = YamboIn('%s -p p -g n -V par' % yambo_exe)
last_k = yambo['QPkrange'][0][1]

#yambo['FFTGvecs'] = [34049,'RL']
yambo['EXXRLvcs'] = [30,'Ry']
yambo['GbndRnge'] = [[1,1000],'']
yambo['QPkrange'] = [ [1,last_k,upper_vb,lower_cb], '' ]
yambo['BndsRnXp'] = [[1,1000],'']
yambo['NGsBlkXp'] = [6,'Ry']

yambo['GTermKind'] = 'BG'
yambo['PPAPntXp'] = [18.8, 'eV']

# parallelization of the RPA
yambo['X_all_q_ROLEs'] = "q k c v"
yambo['X_all_q_CPU']   = "1 1 32 24"
yambo['X_all_q_nCPU_LinAlg_INV'] = 48
# parallelization of the QP correction
yambo['SE_ROLEs'] = "q qp b"
yambo['SE_CPU']   = "1 1 768"

yambo['GfnQPdb']  = "E < ./ndb.QP"
yambo['XfnQPdb']  = "E < ./ndb.QP"

runscript = open("%s.sh" % jobname, "w")
runscript.write("#!/bin/bash\n")
runscript.write("#SBATCH --qos=prace\n")
runscript.write("#SBATCH --time=3-00:00:00\n")
runscript.write("#SBATCH --nodes=16\n")
runscript.write("#SBATCH --ntasks-per-node=48\n")
runscript.write("#SBATCH --job-name=%s\n" % jobname)
runscript.write("\n")
runscript.write("module load intel/2017.4\n")
runscript.write("module load impi/2017.4\n")
runscript.write("module load mkl/2017.4\n")
runscript.write("module load bsc/1.0\n")
runscript.write("module load netcdf\n")
runscript.write("module load fftw\n")
runscript.write("\n")
runscript.write("yambo=%s\n" % yambo_exe)
runscript.write("ypp=%s\n" % ypp_exe)
runscript.write("\n")

yambo_file=jobname + '.in'
yambo.write(yambo_file)

print(yambo_file)

for i in range(5):
  current = jobname + str(i)
  current_job = " -J " + current
  current_file = current + ".in"
  runscript.write("# step " + str(i) + "\n")
  runscript.write("mpirun -np $SLURM_NTASKS $yambo -F " + yambo_file + current_job + "\n")
  runscript.write("$ypp -q g" + current_job + " -F " + current_file + " -Q\n")
  runscript.write("sed -i -e 's/|%3d|%3d|/|%4d|%4d|/g' " % (upper_vb, upper_vb, lower_vb, upper_vb) + current_file + "\n")
  runscript.write("sed -i -e 's/|%3d|%3d|/|%4d|%4d|/g' " % (lower_cb, lower_cb, lower_cb, upper_cb) + current_file + "\n")
  runscript.write("$ypp -J . -F " + current_file + "\n")

runscript.write("# final step\n")
yambo['QPkrange'] = [ [1,last_k,final_vb,final_cb], '' ]
jobname += '_final'
yambo_file=jobname + '.in'
yambo.write(yambo_file)
runscript.write("mpirun -np $SLURM_NTASKS $yambo -F " + yambo_file + " -J " + jobname + "\n")

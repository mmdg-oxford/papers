import sys
import itertools
import os, os.path
import numpy as np
"""
Script for varying a bunch of variables in a bunch of files to generate a bunch of calculations.
Makes a directory for each, labelled by varied variables, i.e. ones with more than one value.
gen_files.py --wstart --wstop --dw --prefix [target root dir] [template/file]
Specify variables in files using new-style python format notation:
"""
#thank you tfgg
def recursive_find(dir):
  files = []
  for f in os.listdir(dir):
    if os.path.isdir(os.path.join(dir, f)):
      files = files + recursive_find(os.path.join(dir, f))
    elif not f.endswith('.pyc'):
      files.append(os.path.join(dir, f))
  return files

def find_all_ext(path, ext, found):
  for file in os.listdir(path):
    file_path = os.path.join(path, file)
    if os.path.isdir(file_path):
      find_all_ext(file_path, ext, found)
    else:
      if ext == file.split('.')[-1]:
        found.append(file_path)

def parse_args(args):
  extra = []
  vars  = []
  current_var = None
  for arg in args:
    if arg.startswith('--'):
      current_var = arg[2:]
    else:
      if current_var is not None:
        vars.append((current_var, arg))
        current_var = None
      else:
        extra.append(arg)
  return (extra, vars)

def split_vars(vars):
  vars_values = []
  for var_name, values in vars:
    values = values.split(",")
    try:
      if any(['.' in value for value in values]):
        values = map(float, values)
      else:
        values = map(int, values)
    except ValueError:
      pass
    vars_values.append((var_name, values))
  vars_dict = dict(vars_values)
  return vars_dict

def freq_grid(wstart, wstop, dw, str='re', delta='0.1'):
  wfs = []
  #For MULTISHIFT First Freq needs to be 0.0d0 0.0d0.
  #print (wstop-(wstart+dw))/dw 
  b = 0.0
  if str=='re':
    for a in np.arange(wstart, wstop,dw):
      wfs.append('{0}  {1}'.format(a,delta))
  elif str=='im':
    for a in np.arange(wstart, wstop,dw):
      wfs.append('0.0d0  {0:.5f}'.format(a))
  return(wfs)

def k_path():
  kpts = []
#reciprocal lattice vectors for MoS2.
#  b1 = [1.0, 0.577350, 0.00]
#  b2 = [0.0, 1.154701, 0.00]
#  b3 = [0.0, 0.00, 5.20]
#for cubic unit cell
  b1 = [1.0, 0.0, 0.0]
  b2 = [0.0, 1.0, 0.0]
  b3 = [0.0, 0.0, 1.0]

  for kxy in np.arange(0, 1.0+0.1, 0.1):
    if np.sqrt(np.square(kxy) + np.square(kxy)) == 0.00:
#modify if you don't wany |k|=0, i.e. for dielectric calculations:
      kpts.append('{0}  {1}  {2}'.format(0.0, 0.0, 0.0))
    else:
      #mos2
      #kpts.append('{0}  {1}  {2}'.format(kxy, b1[1]*kxy + b2[1]*kxy, 0.0))
      kpts.append('{0}  {1}  {2}'.format(0.0, 0.0, kxy))
  return kpts

def any(xs):
  for x in xs:
    if x:
      return True
  else:
    return False

if __name__=='__main__':
  extra, vars = parse_args(sys.argv[1:])
  vars_values = []
  for var_name, values in vars:
    values = values.split(",")
    try:
      if any(['.' in value for value in values]):
        values = map(float, values)
      else:
        values = map(int, values)
    except ValueError:
      pass
    vars_values.append((var_name, values))
  vars = dict(vars_values)

#  if 'wstart' not in vars.keys():
#    vars['wstart'] = 0.0
#  if 'wstop' not in vars.keys():
#  vars['wstop']  = 10.0
#  if 'dw' not in vars.keys():
#   vars['dw']  = 1.0
#  wfs = freq_grid(vars['wstart'][0], vars['wstop'][0], vars['dw'][0])

  prefix = vars['prefix'][0]
  kpts = k_path()
  print kpts

#open sgw, and pbs template file

  for f in os.listdir(extra[1]):
    f = os.path.join(extra[1], f)
    if f.endswith('.pbs'):
      pbs = open(f).read()
    elif f.endswith('.in'):
      template = open(f).read() 
    else:
      print "couldn't find template file."

  target_dir = extra[0]

#template_context = dict(zip([var_name for var_name, _ in vars_values], vars_value))
  template_context        = {}
#  template_context['nws'] = len(wfs)
#  template_context['ws']  = '\n'.join(wfs)
#  template_context['nks'] = 1

#Loop over kpoints, create a directory for each kpt, an sgw input file, and a pbs.
  for i, kpt in enumerate(kpts):
    dir_path=os.path.join(target_dir, '{0}_{1}'.format(prefix, i))
    dir_path=os.path.abspath(dir_path)

    if not os.path.isdir(dir_path):
      os.mkdir(dir_path)
    else:
      print 'directory already made.'

    job_name = '{0}.{1}.in'.format(prefix, i)
    source_target = os.path.join(dir_path, job_name)
    template_context['kpts'] = kpt
    print >> open(source_target,'w'), template.format(**template_context)
    source_name = '{0}.{1}.pbs'.format(prefix,i)
    source_target = os.path.join(dir_path, source_name)
    print >> open(source_target,'w'), pbs.format(jobin=job_name, jdir=dir_path, jobout='{0}.{1}.out'.format(prefix,i))
    if i==0:
      print "qsub ", '{0}/{1}.{2}.pbs'.format(dir_path,prefix,i)
    else:
      print "qsub -hold_jid", '{0}.{1}.pbs'.format(prefix, i-1), '{0}/{1}.{2}.pbs'.format(dir_path,prefix,i)

from __future__ import print_function
from bose_einstein import bose_einstein
from constant import htr_to_meV
import argparser
import mass_factor
import numpy as np

args = argparser.read_argument('Renormalize EPW calculation')
if args.vb: offset = -8.75333295715961e-03
else: offset = 8.53193322468371e-03

if args.vb: band_str = '36'
else: band_str = '37'
temp_str = '%03dK' % args.temp

if args.acoustic:
  rng_qpt = range(8000, 10001, 500)
elif args.temp == 1:
  rng_qpt = range(40000, 50001, 1000)
elif args.temp == 150:
  rng_qpt = range(80000, 100001, 5000)
elif args.temp == 300:
  rng_qpt = range(80000, 100001, 5000)
else:
  print("temperature " + str(args.temp) + " not available")
  exit()

dir_str = 'gx'

for qpt in rng_qpt:
  qpt_str = '%06d' % qpt

  if args.acoustic:
    temp_str = '%dK' % args.temp
    qpt_str = str(qpt)
    filename = 'data/epw_all_28424_'+temp_str+'_5meV_acoustic_only/data_'+dir_str+'_'+band_str+'_'+qpt_str+'.dat'
  else:
    filename = 'data/res_'+temp_str+'_1meV/data_'+dir_str+'_'+band_str+'_'+qpt_str+'.dat'
  file_epw = open(filename, 'r')

  line = file_epw.readline()
  data = line.split()
  lam = np.float(data[4])
  mf = mass_factor.eval(lam, args.method) 

  print(args.temp, mf, lam)


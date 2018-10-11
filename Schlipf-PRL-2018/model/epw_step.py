from __future__ import print_function
from bose_einstein import bose_einstein
from constant import htr_to_K, htr_to_meV
import argparser
import norm_k
import numpy as np
import scf
import system

args = argparser.read_argument('Renormalize EPW calculation')
thres = args.thres / htr_to_meV
beta = htr_to_K / args.temp
window = args.energy / htr_to_meV
if args.vb: offset = -8.75333295715961e-03
else: offset = 8.53193322468371e-03

Sigma = system.make_data(args.dft, args.vb)
Sigma.bose_einstein = bose_einstein(Sigma.freq, beta)

if args.vb: band_str = '36'
else: band_str = '37'
temp_str = '%03dK' % args.temp
if args.acoustic:
  temp_str = '%dK' % args.temp
  qpt_str = '10000'
elif args.temp == 1:
  qpt_str = '050000'
elif args.temp == 150:
  qpt_str = '100000'
elif args.temp == 300:
  qpt_str = '100000'
else:
  print("temperature " + str(args.temp) + " not available")
  exit()

dir_str = args.direction

if args.acoustic:
  filename = 'data/epw_all_28424_'+temp_str+'_5meV_acoustic_only/data_'+dir_str+'_'+band_str+'_10000.dat'
else:
  filename = 'data/res_'+temp_str+'_1meV/data_'+dir_str+'_'+band_str+'_'+qpt_str+'.dat'
file_epw = open(filename, 'r')

for line in file_epw:

  data = line.split()

  eps = np.float(data[1]) - offset
  ImS = np.float(data[2])
  if (abs(eps) < window) and args.method == 2:
    zz = 1.0 / (1.0 + np.float(data[4]))
  else:
    zz = 1.0


  print(eps * htr_to_meV, ImS * zz * htr_to_meV, zz)

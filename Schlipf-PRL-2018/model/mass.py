from __future__ import print_function
from bose_einstein import bose_einstein
from constant import htr_to_K, htr_to_meV, eta
import argparser
import mass_factor
import norm_k
import numpy as np
import scf
import system

args = argparser.read_argument('Evaluate electron-phonon mass')
thres = args.thres / htr_to_meV
Sigma = system.make_data(args.dft, args.vb)

for temp in np.arange(1.0, args.temp, 1.0):

  beta = htr_to_K / temp
  Sigma.bose_einstein = bose_einstein(Sigma.freq, beta)
  Sigma_in = 1j / htr_to_meV
  _, zz = scf.self_energy(1, thres, Sigma, eta, Sigma_in)
  lam = 1.0 / zz - 1.0
  mf = mass_factor.eval(lam, args.method)

  print(temp, mf, zz, lam)

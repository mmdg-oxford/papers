from __future__ import print_function
from bose_einstein import bose_einstein
from constant import htr_to_K, htr_to_meV, htr_to_THz
import argparser
import norm_k
import numpy as np
import scf
import system

args = argparser.read_argument('Evaluate electron-phonon lifetime')
thres = args.thres / htr_to_meV
Sigma = system.make_data(args.dft, args.vb)
norm_k = norm_k.eval(Sigma.eff_mass, args.energy / htr_to_meV)

for temp in np.arange(1.0, args.temp, 1.0):

  beta = htr_to_K / temp
  Sigma.bose_einstein = bose_einstein(Sigma.freq, beta)
  Sigma_in = 0.1j / htr_to_meV
  (Sigma_out, it) = scf.self_energy(args.method, thres, Sigma, norm_k, Sigma_in)

  print(temp, -2.0 * Sigma_out.imag * htr_to_THz, Sigma_out.imag * htr_to_meV, it)

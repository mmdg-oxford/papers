from __future__ import print_function
from bose_einstein import bose_einstein
from constant import htr_to_K, eta, htr_to_meV
import self_energy
import norm_k
import numpy as np
import argparser
import system

args = argparser.read_argument('Evaluate self energy depending on the smearing.')
beta = htr_to_K / args.temp
Sigma = system.make_data(args.dft, args.vb, beta)
norm_k = norm_k.eval(Sigma.eff_mass, args.energy / htr_to_meV)

print("#", norm_k)

for gamma_meV in np.arange(-50.0, 50.0, 0.5):
  Sigma_in = gamma_meV * 1.0j / htr_to_meV
  if abs(Sigma_in) < eta: Sigma_in += eta * 1.0j

  res = self_energy.eval(Sigma, norm_k, Sigma_in)
  print(gamma_meV, res.real * htr_to_meV, res.imag * htr_to_meV)

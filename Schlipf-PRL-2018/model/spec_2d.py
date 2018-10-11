from __future__ import print_function
from bose_einstein import bose_einstein
from constant import htr_to_K, htr_to_meV, bohr_to_A, eta
import argparser
import norm_k
import numpy as np
import spectral
import system

args = argparser.read_argument('Evaluate spectral function of electron-phonon coupling')
beta = htr_to_K / args.temp
energy = args.energy / htr_to_meV

Sigma = system.make_data(args.dft, args.vb)
Sigma.bose_einstein = bose_einstein(Sigma.freq, beta)
norm_k = norm_k.eval(Sigma.eff_mass, energy)
 
omega_vec = np.linspace(-energy, energy, num=400)
spec_gamma = spectral.eval(Sigma, omega_vec, np.array([eta]))
shift = omega_vec[np.argmax(spec_gamma)]
print('# shift = ', shift * htr_to_meV)

omega_vec += shift
k_vec = np.linspace(eta, norm_k, num=100)
spec = spectral.eval(Sigma, omega_vec, k_vec)
for iomega in range(omega_vec.size):
  for ikpt in range(k_vec.size):
    print(k_vec[ikpt] / bohr_to_A, (omega_vec[iomega] - shift) * htr_to_meV, spec[iomega, ikpt] / htr_to_meV)
  print("\n")

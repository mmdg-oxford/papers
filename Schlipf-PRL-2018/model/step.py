from __future__ import print_function
from bose_einstein import bose_einstein
from constant import htr_to_K, htr_to_meV, htr_to_eV
import argparser
import norm_k
import numpy as np
import scf
import system

args = argparser.read_argument('Evaluate step-like feature in electron-phonon coupling')
thres = args.thres / htr_to_meV
beta = htr_to_K / args.temp

Sigma = system.make_data(args.dft, args.vb)
Sigma.bose_einstein = bose_einstein(Sigma.freq, beta)

for energy_meV in np.arange(0.0, args.energy, 0.5):

  energy = energy_meV / htr_to_meV
  kk = norm_k.eval(Sigma.eff_mass, energy)

  Sigma_in = 1e-3j / htr_to_meV
  Sigma_out, it = scf.self_energy(args.method, thres, Sigma, kk, Sigma_in)

  if args.vb: real_energy = -energy
  else: real_energy = energy

  print(real_energy * htr_to_meV, -Sigma_out.imag * htr_to_meV, it)

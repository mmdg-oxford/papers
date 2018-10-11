from __future__ import print_function
from bose_einstein import bose_einstein
from constant import htr_to_K, htr_to_meV, htr_to_fs
import argparser
import norm_k
import numpy as np
import scf
import system

args = argparser.read_argument('Evaluate average scattering time due to electron-phonon coupling')
thres = args.thres / htr_to_meV
(position, weight) = np.polynomial.laguerre.laggauss(100)
Sigma = system.make_data(args.dft, args.vb)

for temp in np.arange(1.0, args.temp, 1.0):
  beta = htr_to_K / temp
  Sigma.bose_einstein = bose_einstein(Sigma.freq, beta)
  energy = position / beta
  Sigma_in = 0.1j / htr_to_meV

  integral = 0
  for (eps, w) in zip(energy, weight):
    kk = norm_k.eval(Sigma.eff_mass, eps)
    Sigma_out, it = scf.self_energy(args.method, thres, Sigma, kk, Sigma_in)
    tau = -1.0 / (2.0 * Sigma_out.imag)
    integral += w * tau
    #print(eps / beta, w, eps * htr_to_meV, tau * htr_to_fs)
  print(temp, 4.0 / (3.0 * np.sqrt(np.pi)) * integral * htr_to_fs)
  #exit() 

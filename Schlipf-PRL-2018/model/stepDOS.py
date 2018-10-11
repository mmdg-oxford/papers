from __future__ import print_function
from bose_einstein import bose_einstein
from constant import htr_to_K, htr_to_meV, htr_to_eV
import argparser
import dos
import kernel
import norm_k
import numpy as np
import system

args = argparser.read_argument('Evaluate step-like feature in electron-phonon coupling (DOS model)')
thres = args.thres / htr_to_meV
beta = htr_to_K / args.temp

Sigma = system.make_data(args.dft, args.vb)
Sigma.bose_einstein = bose_einstein(Sigma.freq, beta)

eps = np.arange(0.0, args.energy, 0.5) / htr_to_meV

if args.dft:
  (vb, cb) = dos.spline_from_file("data/mapbi-dos.samuel", 0.0, 5.0 / htr_to_eV)
else:
  (vb, cb) = dos.spline_from_file("data/mapbi-dos.marina", -3.5 / htr_to_eV, 3.0 / htr_to_eV)
if args.vb:
  dos = vb
  eps *= -1
else:
  dos = cb

# using delta function -> Cauchy turns into pi
sig = kernel.eval(Sigma, dos, args.vb, eps) * np.pi

for (e,s) in zip(eps,sig):
  print(e * htr_to_meV, s * htr_to_meV)

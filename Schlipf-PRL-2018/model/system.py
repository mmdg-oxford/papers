import numpy as np
from bose_einstein import bose_einstein
from constant import bohr_to_A, htr_to_eV
import coupl_io
import self_energy

# unit cell lengths and volume in atomic units
aa = 8.836406  / bohr_to_A
bb = 12.580725 / bohr_to_A
cc = 8.555305  / bohr_to_A
Omega = aa * bb * cc
# reciprocal unit cell and volume
Ga = 2.0 * np.pi / aa
Gb = 2.0 * np.pi / bb
Gc = 2.0 * np.pi / cc
Omega_BZ = Ga * Gb * Gc

# average of diagonal of dielectric constant
epsilon_inf = (5.774494630813 + 6.000381489579 + 5.823740941417) / 3.0

# effective mass for DFT and GW, valence and conduction band
def eff_mass(dft, vb):
  if dft:
    if vb: return 0.14953
    else: return 0.13616
  else:
    if vb: return 0.230
    else: return 0.217

# position of the band edges (used to convert raw data to 0 centered one)
def band_edge(dft, vb):
  if dft:
    if vb: return 2.9520656 / htr_to_eV
    else: return 3.4216505 / htr_to_eV
  else:
   if vb: return -0.32980000 / htr_to_eV
   else: return 1.2427342 / htr_to_eV

def gap(dft):
  vb = True; cb = False
  return band_edge(dft, cb) - band_edge(dft, vb)

def make_data(dft, vb, beta = 1e3):
  Sigma = self_energy.SigmaData
  Sigma.eff_mass = eff_mass(dft, vb)
  if vb: Sigma.sigma = 1.0
  else: Sigma.sigma = -1.0
  (Sigma.freq, Sigma.strength) = coupl_io.read('eff_coupl_sphere.dat')
  Sigma.bose_einstein = bose_einstein(Sigma.freq, beta) 
  Sigma.volumeBZ = Omega_BZ
  return Sigma

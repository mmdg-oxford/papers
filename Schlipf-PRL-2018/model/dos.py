import numpy as np
import system
from constant import htr_to_eV, htr_to_meV
from scipy.interpolate import UnivariateSpline

def spline_from_file(filename, eps_min, eps_max):

  # load data from file

  file_dos = open(filename, 'r')
  eps_dos = np.zeros(0)
  val_dos = np.zeros(0)

  max_vb = system.band_edge(True, True)
  min_cb = system.band_edge(True, False)

  for line in file_dos:
    data = line.split()
    eps = np.float(data[0]) / htr_to_eV
    # factor 1/2 to account for spin degeneracy
    val = np.float(data[1]) * htr_to_eV * 0.5
    if eps > eps_min and eps < eps_max:
      eps_dos = np.append(eps_dos, eps)
      val_dos = np.append(val_dos, val)
      gap = val <= 0.0
      if gap:
        max_vb = min(max_vb, eps)
        min_cb = max(min_cb, eps)

  file_dos.close()

  # spline interpolation

  mask = eps_dos < max_vb
  eps_dos_vb = np.append(eps_dos[mask], max_vb) - max_vb
  val_dos_vb = np.append(val_dos[mask], 0.0)
  # higher weights to enforce parabolic onset
  weight_vb = 1.0 / np.maximum(val_dos_vb, 1e-3)
  spl_dos_vb = UnivariateSpline(eps_dos_vb, val_dos_vb, w=weight_vb, s=6e-4*htr_to_meV, ext=1)

  mask = eps_dos > min_cb
  eps_dos_cb = np.insert(eps_dos[mask], 0, min_cb) - min_cb
  val_dos_cb = np.insert(val_dos[mask], 0, 0.0)
  # higher weights to enforce parabolic onset
  weight_cb = 1.0 / np.maximum(val_dos_cb, 1e-3)
  spl_dos_cb = UnivariateSpline(eps_dos_cb, val_dos_cb, w=weight_cb, s=4e-5*htr_to_meV, ext=1)

  return (spl_dos_vb, spl_dos_cb)

def parabolic(data, eps):
  if data.sigma * eps > 0:
    return 0.0
  return 4.0 * np.pi / data.volumeBZ * np.sqrt(2.0 * data.eff_mass**3 * abs(eps))

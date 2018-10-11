import numpy as np
from constant import eta, htr_to_meV
from scipy.interpolate import UnivariateSpline

def eval(data, dos, vb, eps_vec):

  int_dos = dos.antiderivative()
  # valence band: correct so that DOS = 0 for eps = 0
  if vb: offset = int_dos(int_dos.get_knots()[-1])

  def norm_k(eps):
    if vb:
      val = offset - int_dos(eps)
    else:
      val = int_dos(eps)
    if val < 0:
      return eta
    else:
      return (0.75 * data.volumeBZ / np.pi * val)**(1.0/3.0)

  result = np.zeros(eps_vec.size)
  for i in range(eps_vec.size):
    eps = eps_vec[i]
    kk = max(norm_k(eps), eta)

    current = 0.0
    for (w_v, n_v, a_v2) in zip(data.freq, data.bose_einstein, data.strength):
      for pm in (-1.0, +1.0):

        eps_pm_w = eps + pm * w_v
        k_q = max(norm_k(eps_pm_w), eta)
        dos_q = dos(eps_pm_w) / k_q
        occ = (0.5 * (1.0 + pm * data.sigma) + n_v)
        diff = kk - k_q
        if abs(diff) < eta: diff = eta
        # small imaginary numer to avoid divergence
        log_term = np.log((kk + k_q) / diff + 1.0j * eta).real
        current += a_v2 * occ * dos_q * log_term

    result[i] = 0.5 / kk * current

  return result

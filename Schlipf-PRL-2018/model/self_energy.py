import numpy as np
from constant import eta

class SigmaData:
  eff_mass = 0.0
  sigma = 0.0
  freq = np.zeros(0)
  bose_einstein = np.zeros(0)
  strength = np.zeros(0)
  volumeBZ = 0.0

#                        2  2                                                  -1/2
#                --- 2 pi  g  k                                /     eps +- w  \
# Sigma (eps) = - )  -------v---- [ n + 0.5 (1 +- s ) ] arcsin( 1 - ---------v  )
#      nk        --- Omega  eps      v             n           \        eps    /
#                v,+-     BZ   nk                                          nk
def eval(data, norm_k, Sigma):

  # protect against divergence
  norm_k = max(norm_k, eta)

  eps_nk = -0.5 * data.sigma * norm_k**2 / data.eff_mass
  eps = eps_nk + Sigma
  prefactor = -2.0 * np.pi**2 * norm_k / (data.volumeBZ * eps_nk)

  result = 0.0j
  for (w_v, n_v, g_v2) in zip(data.freq, data.bose_einstein, data.strength):
    for pm in (-1, 1):
      factor = g_v2 * (n_v + 0.5 * (1.0 + pm * data.sigma))
      arg = (1 - (eps + pm * w_v) / eps_nk)**(-0.5)
      result += factor * np.arcsin(arg)

  return prefactor * result

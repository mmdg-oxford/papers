import numpy as np
from constant import eta

def eval(energy, eff_mass):
  return max(np.sqrt(2.0 * eff_mass * energy), eta)

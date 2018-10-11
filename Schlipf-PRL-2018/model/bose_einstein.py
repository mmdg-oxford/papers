import numpy as np

# Bose Einstein distribution
def bose_einstein(eps, beta, mu = 0.0):
  arg = beta * (eps - mu)
  return np.where(arg > 5, np.exp(-arg), 1.0 / (np.exp(arg) - 1.0))

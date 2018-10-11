from constant import mixing, max_iter
import self_energy as self_en

def check_convergence(method, thres, S_in, S_out):
  if method < 4:
    return True
  elif method == 4:
    return abs((S_in - S_out).imag) < thres
  else:
    return abs(S_in - S_out) < thres

def self_energy(method, thres, Sigma, norm_k, Sigma_in):

  for it in range(max_iter):
    Sigma_out = self_en.eval(Sigma, norm_k, Sigma_in)
    if check_convergence(method, thres, Sigma_in, Sigma_out):
      break
    Sigma_in *= (1.0 - mixing)
    Sigma_in += mixing * Sigma_out
    if method == 4: Sigma_in = Sigma_in.imag * 1.0j

  dSigma = self_en.eval(Sigma, norm_k, thres + Sigma_in)
  dSig_dw = (dSigma - Sigma_out) / thres
  if method == 1: 
    it = (1.0 - dSig_dw.real)**-1
  if method == 2:
    it = (1.0 - dSig_dw.real)**-1
    Sigma_out *= it
  if method == 3:
    it = (1.0 - dSig_dw)**-1
    Sigma_out *= it


  return (Sigma_out, it)

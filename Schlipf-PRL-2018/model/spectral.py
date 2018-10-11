from constant import htr_to_meV, eta
import numpy as np
import scf

def eval(Sigma, omega_vec, k_vec):
  Sigma_in = 1.0j / htr_to_meV
  width = 5.0 / htr_to_meV
  inv_sigma2 = (3.0 / width)**2
  shift = np.linspace(-width, +width, num=21)
  weight_vec = np.sqrt(0.5 * inv_sigma2 / np.pi) * np.exp(-inv_sigma2 * shift**2)
  weight_vec /= np.sum(weight_vec)

  spec = np.zeros((omega_vec.size, k_vec.size))
  for iomega in range(omega_vec.size):
    for ikpt in range(k_vec.size):
      ReS = 0; ImS = 0
      for (omega, weight) in zip(omega_vec[iomega] + shift, weight_vec):
        kk = k_vec[ikpt]
        eps_k = -Sigma.sigma * 0.5 * kk**2 / Sigma.eff_mass
        Sigma_in = (omega - eps_k) + 0.1j / htr_to_meV

        (Sigma_out, it) = scf.self_energy(1, eta, Sigma, kk, Sigma_in)
        ReS += Sigma_out.real * weight
        ImS += Sigma_out.imag * weight

      spec[iomega, ikpt] += -ImS / (np.pi * ((omega - eps_k - ReS)**2 + ImS**2))

  return spec

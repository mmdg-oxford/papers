import argparse as ap

def read_argument(description):
  parser = ap.ArgumentParser(description=description)
  parser.add_argument('--vb', dest='vb', action='store_true', help='Calculate valence band (default).')
  parser.add_argument('--cb', dest='vb', action='store_false', help='Calculate conduction band.')
  parser.add_argument('--dft', dest='dft', action='store_true', help='Use DFT effective masses (default).')
  parser.add_argument('--gw', dest='dft', action='store_false', help='Use GW effective masses.')
  parser.add_argument('--thres', default=1e-3, type=float, help='Threshold in meV (default 1e-3); ' \
  + 'used for calculating derivative (method 2 & 3) or self consistency (method 4 & 5).')
  parser.add_argument('--method', default=1, type=int, help='Method used to calculated the self energy: (1, default) ' \
  + 'RS perturbation theory (2) RS + Z factor (3) RS + complex Z factor (4) self-consistent Gamma (5) full self-consistent.')
  parser.add_argument('-t', '--temp', default=310.0, type=float, help='(maximum) temperature or the calculation in K (default 310).')
  parser.add_argument('-e', '--energy', default=0.0, type=float, \
    help='energy in meV relative to the band extrema, where self energy is evaluated (default 0).')
  parser.add_argument('--acoustic', default='acoustic', action='store_true', help='Use acoustic EPW data.')
  parser.add_argument('--direction', default='gx', help='direction along which the correction is calculated (default gx)')
  parser.set_defaults(dft = True, vb = True, below = True, acoustic = False)
  return parser.parse_args()

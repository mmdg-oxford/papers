def eval(lam, method):
  if method == 1:
    return 1.0 / (1.0 - lam / 3.0) - 1.0
  elif method == 2:
    return (1.0 + lam) / (1.0 + 2.0 * lam / 3.0) - 1.0
  else:
    print "method not implemented"
    return 0.0

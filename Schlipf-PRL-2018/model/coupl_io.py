import numpy as np

def read(filename):
  file_coupl = open(filename, 'r')
  
  # count number of lines, i.e. phonon modes
  num_phon = 0
  for line in file_coupl:
    num_phon += 1
  # back to the beginning
  file_coupl.seek(0)
  
  freq = np.zeros(num_phon)
  a_v2 = np.zeros(num_phon)
  
  iphon = 0
  for line in file_coupl:
    data = line.split()
    freq[iphon] = np.float(data[0])
    a_v2[iphon] = np.float(data[1])
    iphon += 1
  
  file_coupl.close()
  if (num_phon != iphon):
    raise Exception('number of phonons inconsistent')

#  freq[2] *= 0.8
#  a_v2[2] /= 0.8
  a_v2[2] = 0.0

  return (freq, a_v2)

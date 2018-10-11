import numpy as np
import matplotlib.pyplot as P
from numpy.linalg import inv
from scipy.interpolate import spline
from pylab import *
import matplotlib.ticker as ticker
from scipy.optimize import curve_fit

P.figure(figsize=(8,4.0))

size=16
rc('axes', linewidth=3)


size = 16

# Solved with Wolfram alpha
tau = np.array([\
0.1   ,\
0.2   ,\
0.3   ,\
0.4   ,\
0.5   ,\
0.6   ,\
0.7   ,\
0.75  ,\
0.8   ,\
0.85  ,\
0.9   ,\
0.92  ,\
0.94  ,\
0.95  ,\
0.951 ,\
0.9512,\
0.9513,\
0.9514,\
])

# Free-energy in eV
delta = np.array([\
 1.000000  ,\
 0.999861  ,\
 0.99675   ,\
 0.983014  ,\
 0.950731  ,\
 0.89272   ,\
 0.799872  ,\
 0.735666  ,\
 0.654838  ,\
 0.549868  ,\
 0.402003  ,\
 0.318219  ,\
 0.19645   ,\
 0.0798863 ,\
 0.0559355 ,\
 0.0497714 ,\
 0.0463835 ,\
 0.0427271 ,\
 ])


P.plot(tau,delta,'-o', color='blue',linewidth=2,label='BCS equation')


tau = np.linspace(0,1,100);
p = 3.3
delta = np.sqrt(1-tau**p);
P.plot(tau,delta,'-', color='red',linewidth=2,label=r'Fit $\delta=\sqrt{1-\tau^{3.3}}$')


P.xticks(fontsize=size)
P.yticks(fontsize=size)

P.xlabel(r'$\tau$',fontsize=size+5)
P.ylabel(r'$\delta$',fontsize=size+5)

#P.legend(loc=3,frameon=False)
P.legend(loc=3, fontsize=size+5)


P.tight_layout()

P.grid('on')
P.show()




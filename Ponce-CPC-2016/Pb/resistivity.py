# S. Ponce: Ziman formula for resistivity of Pb.
# Script to compute the resistivity 

import numpy as np
import matplotlib.pyplot as P
from numpy.linalg import inv
from scipy.interpolate import spline
from pylab import *
import matplotlib.ticker as ticker
from scipy.optimize import curve_fit

# Constants
kelvin2eV= 8.6173427909E-05;
kelvin2Ry = 6.333627859634130e-06;
rhoaum = 2.2999241E6;
meV2Ha = 0.000036749;
ohm2microohmcm = 1E4;
size = 16;
cm2mev = 0.12398 ;
Thz2meV = 4.13567;
ry2ev = 13.605698066 ;
meV2ry = (1.0/(ry2ev*1000));
meV2eV = 0.001;
kB = 6.333620222466232e-06 # Ry/K
rc('axes', linewidth=2)
# ----------------------------------
# a2F_tr(1) = \omega in meV from 0-10 meV
# 4000000 k-point wo SOC with 25000 q-points RND and gaussian of 20meV

a2F = np.loadtxt('pb.a2f_400kSobol_02_tr.04',dtype='float',comments='#')

# meV to ev
a2F[:,0] = a2F[:,0]*meV2ry;


resistivity = [];
for tt in np.arange(1,601):
  T = tt*kelvin2Ry;
  n = 1.0/(np.exp(a2F[:,0]/T)-1);
  func = a2F[:,0]*a2F[:,1]*n*(1+n);
  int = np.trapz(func,a2F[:,0]);
  resistivity.append((196.1075/2)*(pi/T)*int*(1/rhoaum)*1E8);
 
tt = np.linspace(1,600,600);
P.plot(tt,resistivity,linewidth=2, color='blue',label='Present work without SOC');

a2F = np.loadtxt('pb.a2f_400kSobol_02_tr.04_wSOC',dtype='float',comments='#')

# meV to ev
a2F[:,0] = a2F[:,0]*meV2ry;


resistivity = [];
for tt in np.arange(1,601):
  T = tt*kelvin2Ry;
  n = 1.0/(np.exp(a2F[:,0]/T)-1);
  func = a2F[:,0]*a2F[:,1]*n*(1+n);
  int = np.trapz(func,a2F[:,0]);
  resistivity.append((196.1075/2)*(pi/T)*int*(1/rhoaum)*1E8);

tt = np.linspace(1,600,600);
P.plot(tt,resistivity,linewidth=2, color='red',label='Present work with SOC');


####################################################
# Experimental data in micro Ohm per cm
# 63Al2 ref
T1 = np.array([14,20.4,58,77.4,90.31]);
r1 = np.array([0.02,0.560,3.47,4.81,5.69]);

# 73 Mo 1 corrected for thermal expansion
T2 = np.array([80,100,120,140,160,180,200,220,240,260,280,300,320,340,360,380,400]);
r2 = np.array([4.92,6.349,7.78,9.222,10.678,12.152,13.639,15.143,16.661,18.196,19.758,21.35,22.985,24.656,26.358,28.073,29.824]);

# 74 Co1
T3 = np.array([260,273.15,300,350,400,450,500,550]);
r3 = np.array([18.173,19.196,21.308,25.336,29.506,33.832,38.336,43.031]);

# 66 Le 1
T4 = np.array([291.51,367.31,376.97,385.78,407.30,416.20,435.37,454.61,495.61,522.24,541.9,558.86,577.75,585.39,592.14,594.30]);
r4 = np.array([20.75,26.94,27.77,28.53,30.35,31.12,32.76,34.53,38.19,40.64,42.50,44.13,45.98,46.73,47.40,47.62]);

P.plot(T1,r1,'.',markersize=20, color='black',label='Hellwege et al.');
P.plot(T2,r2,'s',markersize=5,markerfacecolor='red', color='red',label='Moore et al.');
P.plot(T3,r3,'d',markersize=5,color='green',label='Cook et al.');
P.plot(T4,r4,'*',markersize=5,color='cyan',label='Leadbetter et al.');

############################

P.xlim([0,600])
P.ylim([0,50])

P.xticks(fontsize=size)
P.yticks(fontsize=size)

P.ylabel('$\rho(\mu\Omega$ cm)',fontsize=size)
P.xlabel('T (K)',fontsize=size)

P.legend(loc=2)

P.rc('text',usetex = True)

#P.grid('on')
P.show()



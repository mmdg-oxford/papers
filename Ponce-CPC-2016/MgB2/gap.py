# S. Ponce: Superconducting gap of MgB2
# Script to compute through finite difference.

import numpy as np
import matplotlib.pyplot as P
from numpy.linalg import inv
from scipy.interpolate import spline
from pylab import *
import matplotlib.ticker as ticker
from scipy.optimize import curve_fit

size=16
rc('axes', linewidth=2)

#gap4 = np.loadtxt('MgB2.imag_aniso_gap0_04.00',dtype='float',comments='#')
gap5 = np.loadtxt('MgB2.imag_aniso_gap0_05.83',dtype='float',comments='#')
gap7 = np.loadtxt('MgB2.imag_aniso_gap0_07.22',dtype='float',comments='#')
gap8 = np.loadtxt('MgB2.imag_aniso_gap0_08.61',dtype='float',comments='#')
gap10 = np.loadtxt('MgB2.imag_aniso_gap0_10.00',dtype='float',comments='#')
gap11 = np.loadtxt('MgB2.imag_aniso_gap0_11.39',dtype='float',comments='#')
gap12 = np.loadtxt('MgB2.imag_aniso_gap0_12.78',dtype='float',comments='#')
gap14 = np.loadtxt('MgB2.imag_aniso_gap0_14.17',dtype='float',comments='#')
gap15 = np.loadtxt('MgB2.imag_aniso_gap0_15.56',dtype='float',comments='#')
gap16 = np.loadtxt('MgB2.imag_aniso_gap0_16.94',dtype='float',comments='#')
gap18 = np.loadtxt('MgB2.imag_aniso_gap0_18.33',dtype='float',comments='#')
gap19 = np.loadtxt('MgB2.imag_aniso_gap0_19.72',dtype='float',comments='#')
gap21 = np.loadtxt('MgB2.imag_aniso_gap0_21.11',dtype='float',comments='#')
gap22 = np.loadtxt('MgB2.imag_aniso_gap0_22.50',dtype='float',comments='#')
gap23 = np.loadtxt('MgB2.imag_aniso_gap0_23.89',dtype='float',comments='#')
gap25 = np.loadtxt('MgB2.imag_aniso_gap0_25.28',dtype='float',comments='#')
gap26 = np.loadtxt('MgB2.imag_aniso_gap0_26.67',dtype='float',comments='#')
gap28 = np.loadtxt('MgB2.imag_aniso_gap0_28.06',dtype='float',comments='#')
gap29 = np.loadtxt('MgB2.imag_aniso_gap0_29.44',dtype='float',comments='#')
gap30 = np.loadtxt('MgB2.imag_aniso_gap0_30.83',dtype='float',comments='#')
gap32 = np.loadtxt('MgB2.imag_aniso_gap0_32.22',dtype='float',comments='#')
gap33 = np.loadtxt('MgB2.imag_aniso_gap0_33.61',dtype='float',comments='#')
gap35 = np.loadtxt('MgB2.imag_aniso_gap0_35.00',dtype='float',comments='#')
gap36 = np.loadtxt('MgB2.imag_aniso_gap0_36.39',dtype='float',comments='#')
gap37 = np.loadtxt('MgB2.imag_aniso_gap0_37.78',dtype='float',comments='#')
gap39 = np.loadtxt('MgB2.imag_aniso_gap0_39.17',dtype='float',comments='#')
gap40 = np.loadtxt('MgB2.imag_aniso_gap0_40.56',dtype='float',comments='#')
gap41 = np.loadtxt('MgB2.imag_aniso_gap0_41.94',dtype='float',comments='#')
gap43 = np.loadtxt('MgB2.imag_aniso_gap0_43.33',dtype='float',comments='#')
gap44 = np.loadtxt('MgB2.imag_aniso_gap0_44.72',dtype='float',comments='#')
gap46 = np.loadtxt('MgB2.imag_aniso_gap0_46.11',dtype='float',comments='#')
gap47 = np.loadtxt('MgB2.imag_aniso_gap0_47.50',dtype='float',comments='#')
gap48 = np.loadtxt('MgB2.imag_aniso_gap0_48.89',dtype='float',comments='#')
gap50 = np.loadtxt('MgB2.imag_aniso_gap0_50.28',dtype='float',comments='#')


#P.plot(gap4[:,0],gap4[:,1]*1000,'-', linewidth=2, color='blue')
# wscut = 1 eV
P.plot(gap5[:,0],gap5[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap7[:,0],gap7[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap8[:,0],gap8[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap10[:,0],gap10[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap11[:,0],gap11[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap12[:,0],gap12[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap14[:,0],gap14[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap15[:,0],gap15[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap16[:,0],gap16[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap18[:,0],gap18[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap19[:,0],gap19[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap21[:,0],gap21[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap22[:,0],gap22[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap23[:,0],gap23[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap25[:,0],gap25[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap26[:,0],gap26[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap28[:,0],gap28[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap29[:,0],gap29[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap30[:,0],gap30[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap32[:,0],gap32[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap33[:,0],gap33[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap35[:,0],gap35[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap36[:,0],gap36[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap37[:,0],gap37[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap39[:,0],gap39[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap40[:,0],gap40[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap41[:,0],gap41[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap43[:,0],gap43[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap44[:,0],gap44[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap46[:,0],gap46[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap47[:,0],gap47[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap48[:,0],gap48[:,1]*1000,'-', linewidth=2, color='blue')
P.plot(gap50[:,0],gap50[:,1]*1000,'-', linewidth=2, color='blue')

####################
# 1-Gap BCS
###############

# Integrated lambda
lambdaa = 0.7474764

#Estimated BCS superconducting gap = 2.4032 meV
bcs_gap = 2.4032
Tc = 51

# Solved with Wolfram Mathematica for each tau value using constant lambda and deduce delta:
# FindRoot[NIntegrate[tanh((1.0/tau)*delta*0.875*sqrt(1+z^2))/sqrt(1+z^2),{z,0,sinh(1/lambda)/delta}]-1/lambda,{delta,0.5}]
#
# FindRoot[NIntegrate[tanh((1.0/0.1)*delta*0.875*sqrt(1+z^2))/sqrt(1+z^2),{z,0,sinh(1/0.7474764)/delta}]-1/0.7474764,{delta,0.5}]

tau = np.array([\
0.1,\
0.2,\
0.3,\
0.4,\
0.5,\
0.6,\
0.7,\
0.8,\
0.9,\
0.92,\
0.93,\
0.935,\
0.938,\
0.94,\
])


delta = np.array([\
1.0,\
0.999848,\
0.99652,\
0.982003,\
0.948074,\
0.887223,\
0.789667,\
0.636003,\
0.357231,\
0.255247,\
0.181727,\
0.129373,\
0.0830248,\
0.0173305])

#P.plot(tau*Tc,delta*bcs_gap,'--', linewidth=2, color='black')

##########
# Alternatively one can fix delta and find tau. This should be more stable because of the 1/delta
#########
#
# FindRoot[NIntegrate[tanh((1.0/tau)*1.0*0.875*sqrt(1+z^2))/sqrt(1+z^2),{z,0,sinh(1/0.7474764)/1.0}]-1/0.7474764,{tau,0.5}]


delta = np.array([\
1.0,\
0.999,\
0.995,\
0.980,\
0.950,\
0.900,\
0.8,\
0.7,\
0.6,\
0.5,\
0.4,\
0.3,\
0.2,\
0.1,\
0.05,\
0.001,\
0.0000001])

tau = np.array([\
0.0438369,\
0.250636,\
0.31791,\
0.408413,\
0.495769,\
0.582758,\
0.691283,\
0.763967,\
0.817605,\
0.858377,\
0.889318,\
0.912135,\
0.927845,\
0.937055,\
0.939334,\
0.940091,\
0.940091])


P.plot(tau*Tc,delta*bcs_gap,'--', linewidth=2, color='red')


# Choi Fitting

Tc = 50.5
delta_0 = 1.7
p = 1.5
temp = np.linspace(0,50.5,51)
delta = np.zeros(51)

jj = 0
for ii in temp:
    delta[jj] = delta_0*np.sqrt(1-(ii/Tc)**p)
    jj += 1

P.plot(temp,delta,'--', linewidth=2, color='black')


delta_0 = 8.8
p = 2.3
temp = np.linspace(0,50.5,51)
delta = np.zeros(51)

jj = 0
for ii in temp:
    delta[jj] = delta_0*np.sqrt(1-(ii/Tc)**p)
    jj += 1

P.plot(temp,delta,'--', linewidth=2, color='black')




############################

P.xlim([0,51])
P.ylim([0,10])

P.xticks(fontsize=size)
P.yticks(fontsize=size)

P.ylabel('$\Delta_{n\mathbf{k}}(\omega=0)$ (meV)',fontsize=size)
P.xlabel('T (K)',fontsize=size)

#P.legend('Present work','Wang et al.','Bouqet et al.','Location','northwest')
#P.legend(loc=2)

P.rc('text',usetex = True)

#P.grid('on')
P.show()




#print "Extrapolated value in infinity ", popt[0]+popt[1]/popt[2]
#

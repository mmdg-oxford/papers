# S. Ponce: Specific heat of MgB2
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

####################

# nswi = 200

temp2 = np.array([\
 1.0,\
 2.0,\
 3.0,\
 4.0,\
 5.0,\
 6.0,\
 7.0,\
 8.0,\
 9.0,\
10.0,\
10.0,\
11.0,\
12.0,\
13.0,\
14.0,\
15.0,\
16.0,\
17.0,\
18.0,\
19.0,\
20.0,\
21.0,\
22.0,\
23.0,\
24.0,\
25.0,\
26.0,\
27.0,\
28.0,\
29.0,\
30.0,\
31.0,\
32.0,\
33.0,\
34.0,\
35.0,\
36.0,\
37.0,\
38.0,\
39.0,\
40.0,\
41.0,\
42.0,\
43.0,\
44.0,\
45.0,\
46.0,\
47.0,\
48.0,\
])

fe2 = np.array([\
-8.3322389327E-06,\
-5.8847613585E-06,\
-5.4788725719E-06,\
-5.3873536564E-06,\
-5.3636876089E-06,\
-5.3492967080E-06,\
-5.3281227485E-06,\
-5.3006045780E-06,\
-5.2569290201E-06,\
-5.2026207737E-06,\
-7.6924194956E-07,\
-5.1332950636E-06,\
-5.0624683724E-06,\
-4.9720868707E-06,\
-4.8793330504E-06,\
-4.7763231904E-06,\
-4.6634433022E-06,\
-4.5381363897E-06,\
-4.3981954030E-06,\
-4.2782465176E-06,\
-4.1350071251E-06,\
-3.9723296438E-06,\
-3.8332522657E-06,\
-3.6818942861E-06,\
-3.5006533917E-06,\
-3.3600132259E-06,\
-3.1945772301E-06,\
-3.0155155373E-06,\
-2.8527308054E-06,\
-2.6817377688E-06,\
-2.5114471482E-06,\
-2.3447320361E-06,\
-2.1736987933E-06,\
-2.0064352453E-06,\
-1.8334375343E-06,\
-1.6749463874E-06,\
-1.4427758063E-06,\
-1.3601171603E-06,\
-1.2088276287E-06,\
-1.0462487785E-06,\
-9.0174417499E-07,\
-7.8252048468E-07,\
-6.6640450103E-07,\
-5.4616989848E-07,\
-4.3681353277E-07,\
-2.9651725653E-07,\
-2.5783286165E-07,\
-1.7508031496E-07,\
-1.0710575873E-07,\
])

ev2mJmol = 96486900;
fe2 = fe2*ev2mJmol

P.plot(temp2,fe2,'-o', color='red',linewidth=3,label=r'nswi=200')


# wscut = 1
# Temperature [K]
h = 1.3888888888

temp = np.array([\
5.83333333,\
7.22222222,\
8.61111111,\
10.0000000,\
11.3888888,\
12.7777777,\
14.1666666,\
15.5555555,\
16.9444444,\
18.3333333,\
19.7222222,\
21.1111111,\
22.5000000,\
23.8888888,\
25.2777777,\
26.6666666,\
28.0555555,\
29.4444444,\
30.8333333,\
32.2222222,\
33.6111111,\
35.0000000,\
36.3888888,\
37.7777777,\
39.1666666,\
40.5555555,\
41.9444444,\
43.3333333,\
44.7222222,\
46.1111111,\
47.5000000,\
48.8888888,\
50.2777777,\
51.6666666,\
])
# Last one is fake 0


# Free-energy in eV
fe = np.array([\
-5.5433902495E-06,\
-5.4371083204E-06,\
-5.3072518808E-06,\
-5.1658021499E-06,\
-5.0092490742E-06,\
-4.8391085540E-06,\
-4.6630258502E-06,\
-4.4758398422E-06,\
-4.2642769199E-06,\
-4.0535788791E-06,\
-3.8451705417E-06,\
-3.6206180244E-06,\
-3.3866047010E-06,\
-3.1562530451E-06,\
-2.9187327487E-06,\
-2.6676367822E-06,\
-2.4311628246E-06,\
-2.1947176937E-06,\
-1.9611147286E-06,\
-1.7160026438E-06,\
-1.5022787796E-06,\
-1.2890604218E-06,\
-1.0784534600E-06,\
-8.8754294660E-07,\
-6.9346450948E-07,\
-5.3305225864E-07,\
-3.8193223030E-07,\
-2.6513725784E-07,\
-1.6092402213E-07,\
-7.2556149741E-08,\
-1.9864096726E-08,\
-4.0912031902E-09,\
-1.7743237583E-10,\
0.000000000000000,\
])

ev2mJmol = 96486900;
fe = fe*ev2mJmol

P.plot(temp,fe,'-o', color='blue',linewidth=3,label=r'wscut=1.0')


# Analytical based on the double gap BCS model
# eV
#delta1 = 0.0017 
#delta2 = 0.0088
#
#temp = np.linspace(1,39,50)
#Kelvin2eV = 8.621738E-5
#tc = 39*Kelvin2eV
#
#fe = np.zeros(50)
#
#jj=0
#for tt in temp:
#    omega = np.pi*tt*Kelvin2eV
#    # First gap
#    p = 2.3
#    delta = delta1*np.sqrt(1-(tt*Kelvin2eV/tc)**p)
#    fe[jj] = -np.pi*tt*Kelvin2eV*(np.sqrt(omega**2+delta**2)-omega)*\
#            (1-(omega)/(np.sqrt(omega**2+delta**2)))
#    # Second gap
#    p = 1.5
#    delta = delta2*np.sqrt(1-(tt*Kelvin2eV/tc)**p)
#    fe[jj] = fe[jj]- np.pi*tt*Kelvin2eV*(np.sqrt(omega**2+delta**2)-omega)*\
#            (1-(omega)/(np.sqrt(omega**2+delta**2)))
#
#    jj += 1
#
#
#fe = fe*ev2mJmol
#
#P.plot(temp,fe,'-o', color='green',linewidth=3,label=r'2-gap BCS')

# Analytical based on the 1-gap BCS model
# eV
# To be set
delta1 = 0.006
lambda1 = 0.7474
cut_freq = 300
cut_energy = 0.12 # eV

temp = np.linspace(0.1,39,100)
fe = np.zeros(100)
Kelvin2eV = 8.621738E-5
tc = 39*Kelvin2eV

jj=0
for tt in temp:
    T = tt*Kelvin2eV
    # First gap
    p = 2.9
    delta = delta1*np.sqrt(1-(T/tc)**p)

    # Compute Z
    Z = np.zeros(cut_freq)
    ZN = np.zeros(cut_freq)

    kk = 0
    for freq in np.arange(0,cut_freq):
        kernel = 0
        kernelN = 0
        for freq2 in np.arange(0,cut_freq):
            omega = (2*freq2+1)*np.pi*T
            if omega < cut_energy:
                kernel += omega*lambda1/(np.sqrt(omega**2+delta**2))
                kernelN += lambda1
            else:
                kernel += lambda1
                kernelN += lambda1

        omega = (2*freq+1)*np.pi
        Z[kk] = 1 + (np.pi*T*kernel)/omega
        ZN[kk] = 1 + (np.pi*T*kernelN)/omega
        kk += 1

    kk = 0
    kernel = 0
    for freq in np.arange(0,cut_freq):
        omega = (2*freq+1)*np.pi*T
        if omega < cut_energy:
            kernel += (np.sqrt(omega**2+delta**2)-omega)*\
                    (Z[kk]-ZN[kk]*omega/(np.sqrt(omega**2+delta**2)))
        else:
          print 'Temperature ',tt  
          print 'Nb of freq for cut_energy=',cut_energy,' is ',freq
          break

    fe[jj] = -np.pi*T*kernel
    jj += 1

fe = fe*ev2mJmol
P.plot(temp,fe,'-o', color='black',linewidth=3,label=r'1-gap BCS')

#### Test more freq




# Do a fit
# Now fit
#fit = np.polyfit(temp,fe,10)
#temp_fine = np.linspace(0,39,200)
#fe_fitted = np.polyval(fit,temp_fine)
#P.plot(temp,fe,'-', color='black',linewidth=3,label=r'1-gap BCS FIT')


#####################

#P.xlim([0,1.1])
#P.ylim([-3,3.2])

P.xticks(fontsize=size)
P.yticks(fontsize=size)

P.xlabel('T K',fontsize=size)
P.ylabel('F',fontsize=size)

#P.legend('Present work','Wang et al.','Bouqet et al.','Location','northwest')
P.legend(loc=1)

P.rc('text',usetex = True)

P.grid('on')
P.show()




#print "Extrapolated value in infinity ", popt[0]+popt[1]/popt[2]
#

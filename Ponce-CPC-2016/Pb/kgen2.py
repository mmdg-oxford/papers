#
# 14/07/2015  Samuel Ponce
#
import numpy as np

i=0
# G-X
a = np.zeros((30))
jj = 0
for ii in np.linspace(0.0,0.5,30):
  a[jj] = ii
  jj += 1

for ii in np.arange(len(a)):
  print '0.0 '+str(a[ii])+' '+str(a[ii])+' '+str(0.0)
  i +=1

#X-W
a = np.zeros((15))
jj = 0
for ii in np.linspace(0.0,0.25,15):
  a[jj] = ii
  jj += 1

b = np.zeros((15))
jj = 0
for ii in np.linspace(0.5,0.75,15):
  b[jj] = ii
  jj += 1

for ii in np.arange(len(a)):
  print str(a[ii])+' 0.5 '+str(b[ii])+' '+str(0.0)
  i +=1

#W-L
a = np.zeros((21))
jj = 0
for ii in np.linspace(0.25,0.5,21):
  a[jj] = ii
  jj += 1

b = np.zeros((21))
jj = 0
for ii in np.linspace(0.75,0.5,21):
  b[jj] = ii
  jj += 1

for ii in np.arange(len(a)):
  print str(a[ii])+' 0.5 '+str(b[ii])+' '+str(0.0)
  i +=1

#L-K
a = np.zeros((18))
jj = 0
for ii in np.linspace(0.5,0.375,18):
  a[jj] = ii
  jj += 1

b = np.zeros((18))
jj = 0
for ii in np.linspace(0.5,0.75,18):
  b[jj] = ii
  jj += 1

for ii in np.arange(len(a)):
  print str(a[ii])+' '+str(a[ii])+' '+str(b[ii])+' '+str(0.0)
  i +=1

# K-G
a = np.zeros((32))
jj = 0
for ii in np.linspace(0.375,0.0,32):
  a[jj] = ii
  jj += 1

b = np.zeros((32))
jj = 0
for ii in np.linspace(0.75,0.0,32):
  b[jj] = ii
  jj += 1

for ii in np.arange(len(a)):
  print str(a[ii])+' '+str(a[ii])+' '+str(b[ii])+' '+str(0.0)
  i +=1

#G-L
a = np.zeros((26))
jj = 0
for ii in np.linspace(0.0,0.5,26):
  a[jj] = ii
  jj += 1

for ii in np.arange(len(a)):
  print str(a[ii])+' '+str(a[ii])+' '+str(a[ii])+' '+str(0.0)
  i +=1



print i

#K_POINTS crystal_b
#  7
#   0.00 0.00 0.00 30 ! G
#   0.00 0.50 0.50 15 ! X
#   0.25 0.50 0.75 21 ! W
#   0.50 0.50 0.50 18 ! L
#   0.375 0.375 0.75 32 ! K
#   0.00 0.00 0.00 26 ! G
#   0.50 0.50 0.50 1  ! L

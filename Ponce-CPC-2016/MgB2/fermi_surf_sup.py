import sys
import re
import numpy as np
from   gen_files import parse_args, split_vars

#f is a string with the contents of the file
class FermiSurface(object):
  def __init__(self):
    self.nx = 60
    self.ny = 60
    self.nz = 60
    self.dimvec = np.array([float(self.nx), float(self.ny), float(self.nz)])
    self.fermixyz = {}
    self.muk = {}
    self.prefix = 'MgB2'
    self.nbndmin = 2
    self.nbndmax = 4

  def __repr__(self):
    return 'Fermi Surface/Mu Tensor Object'

#should have the in pwstruct module, and also read the crystal,
#and reciprocal space coordinates direct from the pw output.
  def cryst_to_cart(self, kvec):
#Pb crystal axes
#    at1 = np.array([-0.500000,   0.000000,  0.500000])
#    at2 = np.array([ 0.000000,   0.500000,  0.500000])
#    at3 = np.array([-0.500000,   0.500000,  0.000000])
#MgB2 crystal axes
    at1 = np.array([ 1.000000,   0.000000,   0.000000])
    at2 = np.array([-0.500000,   0.866025,   0.000000])
    at3 = np.array([ 0.000000,   0.000000,   1.142069])
#CaC6 crystal axes
#    at1 = np.array([ 1.000000,   0.000000,   0.000000])
#    at2 = np.array([-0.500000,   0.866025,   0.000000])
#    at3 = np.array([ 0.000000,   0.000000,   3.535284])  
#crystal to cart BG CaC6
#    at1 = np.array([ 1.000000,   0.00,       0.000000])
#    at2 = np.array([ 0.577350,   1.154701,   0.000000])
#    at3 = np.array([ 0.000000,   0.000000,   0.282863])  

    at  = np.array([at1, at2, at3])
    outvec = np.dot( kvec,at)
    return outvec

  def cart_to_cryst(self, kvec):
#crystal to cart BG MgB2
    at1 = np.array([ 1.000000,  -0.500000,   0.000000])
    at2 = np.array([ 0.000000,   0.866025,   0.000000])
    at3 = np.array([ 0.000000,   0.000000,   1.142069])
#crystal to cart BG CaC6
#    at1 = np.array([ 1.000000,   0.577350,   0.000000])
#    at2 = np.array([ 0.000000,   1.154701,   0.000000])
#    at3 = np.array([ 0.000000,   0.000000,   0.282863])  
    at  = np.array([at1, at2, at3])
    outvec = np.dot(kvec,at)
    return outvec

  def pull_fermi(self,f):
    fermi_regex  = re.compile(r'k\s=\s?(\-?[0-9\.]+)\s?(\-?[0-9\.]+)\s?(\-?[0-9\.]+).*?:\n\n\s+([0-9\.\-\s]+)')
    print len(fermi_regex.findall(f))
    for a, b, c, d in fermi_regex.findall(f):
      a = float(a)
      b = float(b)
      c = float(c)
      kvec = np.array([a,b,c])
      d = map(float, d.split())
#turn kpoint coordinates into cartesian coordinates:
      kvec = self.cryst_to_cart(kvec)
      # DBSP
      #print 'kvec', kvec
#fold into first brillouin zone:
      for i, a in enumerate(kvec):
        if (a< -0.001): kvec[i] = kvec[i] + 1.0
      index = [round(a) for a in np.multiply(kvec, self.dimvec)]
      #DBSP
      #print 'index ',index
      #print 'd ',d
      # Rescale the energy so that the Fermi level = 0
      d[:] = [x - 7.4272 for x in d]

      for i, a in enumerate(index):
        if index[i] == 61.0: 
          index[i] = 0.0
      print index
      self.fermixyz[tuple(index)] = d

  def pull_fermi_xy(self,f):
    fermi_regex  = re.compile(r'k\s=\s?(\-?[0-9\.]+)\s?(\-?[0-9\.]+)\s?(\-?[0-9\.]+).*?:\n\n\s+([0-9\.\-\s]+)')
    print len(fermi_regex.findall(f))
    for a, b, c, d in fermi_regex.findall(f):
      a    = float(a)
      b    = float(b)
      c    = float(c)
      kvec = np.array([a,b,c])
      d    = map(float, d.split())
# Turn kpoint coordinates into integer indices
# and fold back into the first Brillouin zone.
      kvec = self.cryst_to_cart(kvec)
# Fold into first Brillouin zone:
      for i, a in enumerate(kvec):
        if (a<0.0): kvec[i] = kvec[i] + 1.0
      index = [round(a) for a in np.multiply(kvec, self.dimvec)]
      for i, a in enumerate(index):
        if index[i] == 61.0:
          index[i] = 0.0     
#Back to Cartesian
      kvec = self.cart_to_cryst(kvec)
#If kpoint has eigenvalue within energy window of fermi
#surface print and color based on band index.
      col2 = 0.0
      col1 = 0.25
      col3 = 0.5
      col4 = 1.0
      col5 = 0.95
      for ibnd, eig in enumerate(d):
        if 2.58 <= eig <= 2.83:
#       print '{0:12.7f} {1:12.7f} {2:12.7f}'.format(kvec[0], kvec[1], eig)
          if ibnd == 28:
            print '{0:12.7f} {1:12.7f} {2:12.7f}'.format(kvec[0], kvec[1], col5)
          elif ibnd == 32:
            print '{0:12.7f} {1:12.7f} {2:12.7f}'.format(kvec[0], kvec[1], col1)
          elif ibnd == 29:
            print '{0:12.7f} {1:12.7f} {2:12.7f}'.format(kvec[0], kvec[1], col4)
          elif ibnd == 30:
            print '{0:12.7f} {1:12.7f} {2:12.7f}'.format(kvec[0], kvec[1], col3)
          elif ibnd == 31:
            print '{0:12.7f} {1:12.7f} {2:12.7f}'.format(kvec[0], kvec[1], col2)
          else:
            print 'band out of range.'

#pass file with kpoints
  def order_klist(f):
#pass file with kpoints written in format {kx} {ky} {value}
    f = open('muk_cart_full.dat','r').read().split('\n')
    kpoints=[]
    for line in f:
      kpoints.append(map(float,line.split()))
#Order points x, y with y varying the quickest:
      kpoints.sort(key=lambda x:(x[0], x[1]))
      return kpoints

#returns dictionary keys:xyz coordinates, values:eigenvalues.
  def print_xsf(self, surf, title='band', band1=1):
    for ibnd in range(band1):
      f1 = open('{0}.col.band{1}.xsf'.format(self.prefix, ibnd), 'w')
      print >>f1, "BEGIN_BLOCK_DATAGRID_3D" 
      print >>f1, "{0}_band_{1}".format(self.prefix, ibnd)     
      print >>f1, " BEGIN_DATAGRID_3D_{0}".format(self.prefix) 
      print >>f1, " {0}  {1}  {2} ".format(self.nx, self.ny, self.nz)
      print >>f1, "0.000000  0.000000  0.000000"   
    #Pb
     # print >>f1, "-1.000000 -1.000000  1.000000"
     # print >>f1, " 1.000000  1.000000  1.000000"
     # print >>f1, "-1.000000  1.000000 -1.000000"
     # print >>f1, ""
    #MgB2:
      print >>f1, "1.000000  0.577350  0.000000"
      print >>f1, "0.000000  1.154701  0.000000"
      print >>f1, "0.000000  0.000000  0.875604"
      print >>f1, ""
    #CaC6:
      #print >>f1, "1.000000  0.577350  0.000000"
      #print >>f1, "0.000000  1.154701  0.000000"
      #print >>f1, "0.000000  0.000000  0.282863"
      #print >>f1, ""
      
      #Total number of points added
      total = 0
      for z in range(self.nz):
        for y in range(self.ny):
          for x in range(self.nx):
            try:
              print>>f1, surf[x,y,z], " ",
              #print>>f1, "0.05", " ",
              total = total+ 1 
            except TypeError:
              print>>f1, surf[x,y,z], " ",
              print 'Missing key'
              print>>f1, "0.0", " ",
            except KeyError:
              print 'Missing key' 
              print>>f1, "0.0", " ",
          print >> f1, ""
        print >> f1, ""
      print >>f1, "END_DATAGRID_3D"  
      print >>f1, "END_BLOCK_DATAGRID_3D"  
      f1.close()
      print 'Total number of data ',total

  def pull_muk(self, f):
#division along x,y,z
    total = 0
    for line in f.split('\n'):
      try:
        a,b,c,d,e,f = map(float, line.split())
# Because the _FS is in Cartesian we need to
        # Fold back into first BZ
        #if (b > 1.154701): b = b - 1.154701

        #b = b*(np.sqrt(3)/2)
        #c = c/0.875604
# Do one band manually
        if d == 2:
          kvec = np.array([a,b,c])
          kvec = self.cart_to_cryst(kvec)

          index = [round(ii) for ii in np.multiply(kvec, self.dimvec)]
          #TEST
          if index[0] > 60:  
            print 'ERROR', kvec, a,b,c
            print line
          if index[1] > 60:
            print 'ERROR', kvec, a,b,c
            print line
          if index[2] > 60:
            print 'ERROR', kvec, a,b,c
            print line

          print index
#might need to duplicate values so the colour map is right.
          self.muk[tuple(index)] = f
          total += 1
      except:
        print "Couldn't read the following line:"
        print line

  #  for z in range(self.nx):
  #    for y in range(self.ny):
  #      for x in range(self.nz):
  #        try:
  #          print>>f1, self.muk[x,y,z], " ",
  #        except KeyError:
  #          print 'key error'
  #          print x,y,z
  #          pass
  #      print >> f1, ""
  #    print >> f1, ""
    print 'Total number of lines extracted ',total  

if __name__=="__main__":
# run as: 
# python --fs y ./nscf.out to parse band file and make fermiplot
# else run as:
# python --muk y ./fort.5000 to parse muk plot.
  extra, vars = parse_args(sys.argv[1:])
  vars_values = []

  vars = split_vars(vars)
  print vars, extra

  f = open(extra[0]).read()
  fs = FermiSurface()

  if 'fs' in vars.keys():
    fs.pull_fermi(f)
    fs.print_xsf(fs.fermixyz, band1=2, band2=3, band3=4)

  if 'fsxy' in vars.keys():
    fs.pull_fermi_xy(f)

  if 'muk' in vars.keys():
    fs.pull_muk(f)
    fs.print_xsf(fs.muk, 'muk')

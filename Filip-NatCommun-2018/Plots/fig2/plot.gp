set terminal postscript eps color enhanced font 'Helvetica,20' linewidth 1 size 6,6
set output "main.eps"

set lmargin 10
set multiplot layout 2,2 margins 0.11,0.94,0.11,0.94 spacing 0.1,0.2 


set size square
set key off
set ylabel offset -0.2

######## Band structure ########

set origin 0.0,0.265
set size square
set title "{/Bold (a)}" offset -15

x1=0
x2=2.7882500
y1=-1.2
y2=3.8
haev = 27.2113
bohr = 0.529177
vbt = -0.33
cbb = 1.24
kshift = 1.2104420


set ylabel "Energy (eV)" offset  2

set xrange [x1:x2]
set yrange [y1:y2]

set arrow from  x1,y1 to  x1,y2 nohead lw 0.5 front
set arrow from 0.3556,y1 to 0.3556,y2 nohead lw 0.1 lt "dashed" front 
set arrow from 0.6039,y1 to 0.6039,y2 nohead lw 0.1 lt "dashed" front 
set arrow from 0.9437,y1 to 0.9437,y2 nohead lw 0.1 lt "dashed" front 
set arrow from 1.2129,y1 to 1.2129,y2 nohead lw 0.1 lt "dashed" front 
set arrow from 1.5836,y1 to 1.5836,y2 nohead lw 0.1 lt "dashed" front 
set arrow from 1.9449,y1 to 1.9449,y2 nohead lw 0.1 lt "dashed" front 
set arrow from 2.2008,y1 to 2.2008,y2 nohead lw 0.1 lt "dashed" front 
set arrow from 2.5420,y1 to 2.5420,y2 nohead lw 0.1 lt "dashed" front 
set arrow from x2,y1 to x2,y2 nohead lw 0.5 front 

set arrow heads filled size screen 0.01,30,60 from 1.2429, 0 to 1.2429, -vbt+cbb lw 3  
set arrow heads filled size screen 0.01,30,60 from 1.1829, -0.38 to 1.1829, -vbt+cbb lw 3 lc "red" 

set label "C1" at 1.2129,-vbt+cbb-0.1 offset -2.35
set label "V1" at 1.2129,0 offset 0.5 
set label "V2" at 1.2129,-0.58 offset -2.35 

set label "1.57 eV" at 1.2129, 0.8 offset 0.5 
set label "1.95 eV" at 1.2129, 0.8 offset -6.35 tc "red" 

unset xtics


set xtics ("{/Symbol G}" x1, "X" 0.3556, "S" 0.6039, "Y" 0.9437, "{/Symbol G}" 1.2129, "Z" 1.5836, "U" 1.9449, "R" 2.2008, "T" 2.5420, "Z" x2)

set format y "%.1f"
set ytics 0.5

plot "ss-gw.band.dat" u 1:($2-vbt)  w l lt 1 lc "blue" lw 3

unset arrow
unset label
##### JDOS

set title "{/Bold (b)}" offset -15
set origin 0.5,0.25
set size 0.5,0.5

set xrange [1.4:2.2]
set yrange [0:0.21]

set ytics 0.10
set xtics 0.2
set format x "%.1f"
set mytics 

set arrow nohead from 1.5,0.19 to 1.6, 0.19 lc "blue" lw 4
set arrow nohead from 1.5,0.172 to 1.6, 0.172 lc "black" lw 4

set label "GW" at 1.6,0.19 offset 1
set label "Parabolic model" at 1.6,0.172 offset 1


set arrow head filled size screen 0.01,30,60 from 1.573,0.05 to 1.573,0.03 lc "black" lw 2
set label "V1{/Symbol \256}C1" at 1.57,0.06 offset -3.2 

set arrow head filled size screen 0.01,30,60 from 1.95,0.13 to 1.95,0.11 lc "red" lw 2
set label "V2{/Symbol \256}C1" at 1.95,0.14 offset -3.2 




set xlabel "Energy (eV)"
set ylabel "Joint density of states (eV^{-1})" offset 1

mu = 0.110357612
gap = 1.572534211
pi = 3.141592654
volume = 6418.1229
haev = 27.2113

fquad(x)  = (x>gap) ? 1.0/4.0/pi**2.0*(2.0*mu)**1.5*(gap/haev)**0.5*(x/gap-1.0)**0.5/haev: 0

plot 'jdos.dat' u 1:2 w l lw 4 lc "blue",fquad(x)*volume w l lw 4 lc "black"

unset mytics
unset arrow
unset label
######### MATRIX ELEMENT 

set origin 0,0
set size 0.5,0.5
set title "{/Bold (c)}" offset -15

# constants in SI
e    = 1.60217662*10**(-19)
haev = 27.2113
haj  = 27.2113*e
mass = 9.10938356*10**(-31)
pi   = 3.14159265359
hbar = 1.0545718*10**(-34)
coul = 9.0*10**9
bohr = 0.529177*10**(-10)
momev = 5.344286*10**(-25.0) # from SI to keV/c
velocity = 2.1876912633*10**6  

# in SI
const  = bohr**3.0*haj**3.0*mass**2.0/e**2.0/hbar**2.0/coul

# direct SI
const3 = (mass*velocity)**2.0


# in (keV/c)^2
const2 = momev**2.0

set logscale y
set xrange [1.4:2.2]
set yrange [0.01:100]

set xtics 0.2

set format y "10^{%L}"
# set ytics ("10^{-2}" 0.01, "10^{-1}" 0.1, "10^0" 1, "10^1" 10) offset 0.5 scale 1.2,1
set mytics

set ylabel "Dipole matrix element (keV^2c^{-2})" offset 0.5
set xlabel "Energy (eV)" 

set label "V1{/Symbol \256}C1" at 1.59,0.05 
set label "V2{/Symbol \256}C1" at 1.96,0.05 

plot "direct_matel_gw.dat" u 1:($2*const/const2) w p pt 7 ps 1 lc "grey", "average_matel_gw.dat" u 1:($2*const/const2) w l lw 3 lc "blue", "direct_matel_gw.dat" u 3:($4*const/const2) w p pt 7 ps 1 lc "grey", "average_matel_gw.dat" u 1:($3*const/const2) w l lw 3 lc "blue"

unset logscale
unset label
unset format 
unset mytics

######## ABSORPTION
set origin 0.5, 0 
set size 0.5,0.5

set title "{/Bold (d)}" offset -15
set xrange [1.4:2.2]
set yrange [0:6]

set xtics 0.2
set ytics 1 offset 0 
set format x "%.1f"

shiftdft = 1.155
shiftgw = 0.085
n = 2.41
c = 137
bohrcm = 0.529177*10**(-8.0)
haev = 27.2113

set ylabel offset 0.5
set ylabel "Absorption coefficient (x 10^4 cm^{-1})"  
set xlabel "Energy (eV)"

# set arrow nohead from 1.5,5.5 to 1.6,5.5 lc "red" lw 4
# set label "Experiment" at 1.6,5.5 offset 1

set arrow nohead from 1.5,5.5 to 1.6,5.5 lc "black" lw 4
set label "DFT" at 1.6,5.5 offset 1

set arrow nohead from 1.5,5.0 to 1.6,5.0 lc "blue" lw 6 lt "dashed"
set label "GW not scaled" at 1.6,5.0 offset 1

set arrow nohead from 1.5,4.5 to 1.6,4.5 lc "blue" lw 4 
set label "GW scaled" at 1.6,4.5 offset 1

set style fill solid 0.2 

plot 'abs-gw.dat' u 1:2:3 w filledcu lc "royalblue", 'abs-gw.dat' u 1:2 w l lw 4 lc "blue", 'abs-gw.dat' u 1:3 w l lw 6 lc "blue" lt "dashed", 'abs.dat' u 1:2 w l lw 2 lc "black" 




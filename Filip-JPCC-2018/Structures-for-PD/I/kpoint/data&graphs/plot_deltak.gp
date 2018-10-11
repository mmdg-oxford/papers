set terminal postscript eps enhanced color font 'Verdana,20'
set output "I_kp_deltak.eps"
unset key

set grid ytics lc rgb "#bbbbbb" lw 1 lt 0
set grid xtics lc rgb "#bbbbbb" lw 1 lt 0

set xrange [0:0.4]
set yrange [-3:3]
set title "I kpoint"
set xlabel "Delta K(A^-^1)"
set ylabel "Energy Difference/atom(meV)"
f(x)= 1
g(x)= -1

plot "I_kp.txt" u (1/$1):(($2+233.86840976)*13.605698066*1000/4) w lp lw 2 pt 2, f(x) lt 2 lc rgb "blue" lw 3, g(x) lt 2 lc rgb "blue" lw 3


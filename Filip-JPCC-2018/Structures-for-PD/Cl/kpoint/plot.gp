set terminal postscript eps enhanced color font 'Verdana,10'
set output "PBE.eps"

set grid ytics lc rgb "#bbbbbb" lw 1 lt 0
set grid xtics lc rgb "#bbbbbb" lw 1 lt 0

set yrange [-3:3]
set title "PBE-kpoint"
set xlabel "Multiple"
set ylabel "Energy Difference/atom(meV)"

plot "PBE.txt" u 1:(($2+184.49515293)*13.605698066*1000) w lp lw 2 pt 2

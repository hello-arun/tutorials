set style data dots
mm=72.0/25.4 # Since 1pt = 1/72 inch
set terminal svg size 100*mm, 100*mm enhanced background rgb 'white' font "Latin Modern Roman,14"
set output "fig-bands_wan.svg"

#set lmargin 1
#set bmargin 1
#set rmargin 0.1
#set tmargin 0.1

set ylabel "Energy" offset 2,0
#set xlabel "X-axis Title" offset 0,1

set key bottom right samplen 1 

set xrange [*:*] noextend
set x2range [*:*] noextend
ymin=-10
ymax=20
set yrange [ ymin: ymax]
#set arrow from  1.26915,  ymin to  1.26915,  ymax nohead
#set arrow from  1.90372,  ymin to  1.90372,  ymax nohead
#set arrow from  2.80114,  ymin to  2.80114,  ymax nohead
#set arrow from  3.90025,  ymin to  3.90025,  ymax nohead
#set xtics ("G"  0.00000,"X"  1.26915,"W"  1.90372,"L"  2.80114,"G"  3.90025,"K"  5.69510) offset 0,0.5
plot \
"ex1_band.dat" w l ls 1 title "Wannier90", \
"bands.dat.gnu" w p pt 6 ps 0.2 title "Espresso" axes x2y1

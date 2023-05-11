set style data dots
mm=72.0/25.4 # Since 1pt = 1/72 inch
set terminal svg size 100*mm, 100*mm enhanced background rgb 'white' font "Latin Modern Roman,20"
set output "fig-bands_wan.svg"

set lmargin 4.5
set bmargin 1.0
set rmargin 0.5
set tmargin 0.1

set ylabel "Energy" offset 2.5,0
#set xlabel "X-axis Title" offset 0,1
espressoBandData="../../../01-espressoBands/calc/final/bi2se3-bands-bulk-soc-02.dat.gnu"
set key bottom right samplen 1 

set xrange [*:*] noextend
set x2range [*:*] noextend
ymin=4
ymax=15
set yrange [ ymin: ymax]
set arrow from  0.32908,   ymin to  0.32908,  ymax nohead lw 1 lc rgb "gray"
set arrow from  1.21257,   ymin to  1.21257,  ymax nohead lw 1 lc rgb "gray"
set arrow from  2.11626,   ymin to  2.11626,  ymax nohead lw 1 lc rgb "gray"
set xtics ("G"  0.00000,"Z"  0.32908,"F"  1.21257,"G"  2.11626,"L"  2.99975) offset 0,0.5
plot \
"10-wannier90_band.dat" w l ls 1 title "Wannier90", \
espressoBandData w p lc rgb "black" pt 6 ps 0.2 title "Espresso" axes x2y1
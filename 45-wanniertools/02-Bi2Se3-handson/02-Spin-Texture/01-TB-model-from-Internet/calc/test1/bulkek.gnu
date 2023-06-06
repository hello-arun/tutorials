set terminal pdf enhanced color font ",30"
set palette defined ( 0  "green", 5 "yellow", 10 "red" )
set output 'bulkek.png'
set style data linespoints
unset ztics
unset key
set pointsize 0.8
set view 0,0
set xtics font ",24"
set ytics font ",24"
set ylabel font ",24"
set ylabel offset 0.5,0
set xrange [0:    2.99975]
emin=   -6.048624
emax=    5.603166
set ylabel "Energy (eV)"
set yrange [ emin : emax ]
set xtics ("G  "    0.00000,"Z  "    0.32908,"F  "    1.21257,"G  "    2.11626,"L  "    2.99975)
set arrow from    0.32908, emin to    0.32908, emax nohead
set arrow from    1.21257, emin to    1.21257, emax nohead
set arrow from    2.11626, emin to    2.11626, emax nohead
# please comment the following lines to plot the fatband 
plot 'bulkek.dat' u 1:2  w lp lw 2 pt 7  ps 0.2 lc rgb 'black', 0 w l lw 2
 
# uncomment the following lines to plot the fatband 
#plot 'bulkek.dat' u 1:2:3  w lp lw 2 pt 7  ps 0.2 lc palette, 0 w l lw 2

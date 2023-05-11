set style data dots
set nokey
set xrange [0: 2.99975]
set yrange [  3.92529 : 15.57319]
set arrow from  0.32908,   3.92529 to  0.32908,  15.57319 nohead
set arrow from  1.21257,   3.92529 to  1.21257,  15.57319 nohead
set arrow from  2.11626,   3.92529 to  2.11626,  15.57319 nohead
set xtics ("G"  0.00000,"Z"  0.32908,"F"  1.21257,"G"  2.11626,"L"  2.99975)
 plot "10-wannier90_band.dat"

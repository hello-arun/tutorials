set style data dots
set nokey
set xrange [0: 2.99975]
set yrange [  4.01460 : 15.50263]
set arrow from  0.32908,   4.01460 to  0.32908,  15.50263 nohead
set arrow from  1.21257,   4.01460 to  1.21257,  15.50263 nohead
set arrow from  2.11626,   4.01460 to  2.11626,  15.50263 nohead
set xtics ("G"  0.00000,"Z"  0.32908,"F"  1.21257,"G"  2.11626,"L"  2.99975)
 plot "10-wannier90_band.dat"

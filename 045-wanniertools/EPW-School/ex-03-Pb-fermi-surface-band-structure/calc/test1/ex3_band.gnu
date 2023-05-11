set style data dots
set terminal svg enhanced background rgb 'white'
set nokey
set output "fig-bands_wan.svg"
set xrange [*:*]
set yrange [ 5: 15]
#set arrow from  1.26915,  -6.97702 to  1.26915,  19.79141 nohead
#set arrow from  1.90372,  -6.97702 to  1.90372,  19.79141 nohead
#set arrow from  2.80114,  -6.97702 to  2.80114,  19.79141 nohead
#set arrow from  3.90025,  -6.97702 to  3.90025,  19.79141 nohead
set xtics ("G"  0.00000,"X"  1.26915,"W"  1.90372,"L"  2.80114,"G"  3.90025,"K"  5.69510)
 plot "ex3_band.dat"

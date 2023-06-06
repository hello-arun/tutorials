set encoding iso_8859_1
#set terminal pngcairo truecolor enhanced font ",80" size 3680, 3360
set terminal png truecolor enhanced font ",80" size 3680, 3360
set output 'spintext_r.png'
set palette defined ( -6 "white", 0 "white", 10 "black" )
set multiplot layout 1,1 
set origin 0.06, 0.0
set size 0.9, 0.9
set xlabel 'K_1'
set ylabel 'K_2'
unset key
set pm3d
set xtics nomirror scale 0.5
set ytics nomirror scale 0.5
set border lw 6
set size ratio -1
set view map
unset colorbox
set xrange [  -0.15184:   0.15184]
set yrange [  -0.26300:   0.26300]
set pm3d interpolate 2,2
set label 1 'Spin texture' at graph 0.25, 1.10 front
splot 'arc.dat_r' u 1:2:3 w pm3d, \
     'spindos.dat_r' u 1:2:(0):($3/5.00):($4/5.00):(0)  w vec  head lw 5 lc rgb 'orange' front

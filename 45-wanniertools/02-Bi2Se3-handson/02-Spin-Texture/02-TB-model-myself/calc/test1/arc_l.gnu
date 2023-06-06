set encoding iso_8859_1
#set terminal  postscript enhanced color
#set output 'arc_l.eps'
#set terminal pngcairo truecolor enhanced  font ",50" size 1920, 1680
set terminal png truecolor enhanced font ",50" size 1920, 1680
set output 'arc_l.png'
set palette defined ( -10 "#194eff", 0 "white", 10 "red" )
#set palette rgbformulae 33,13,10
unset ztics
unset key
set pm3d
set border lw 6
set size ratio -1
set view map
set xtics
set ytics
set xlabel "K_1 (1/{\305})"
set ylabel "K_2 (1/{\305})"
set ylabel offset 1, 0
set colorbox
set xrange [-0.15184: 0.15184]
set yrange [-0.26300: 0.26300]
set pm3d interpolate 2,2
splot 'arc.dat_l' u 1:2:3 w pm3d

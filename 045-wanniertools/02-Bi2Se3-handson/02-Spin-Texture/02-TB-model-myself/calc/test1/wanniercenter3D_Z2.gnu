 set encoding iso_8859_1 
 set terminal  postscript enhanced color font ",18"
 set output "wanniercenter3D_Z2.eps"
 set size 0.6,1.0
 set multiplot 
 unset key 
 set border lw 1 
 NOXTICS = "set format x ''; unset xtics; unset xlabel"
 XTICS = "set xtics format '%4.1f'; set xtics 0.5 nomirror in offset 0, 0.3; set mxtics 5;"
 NOYTICS = "set format y  '';unset ylabel"
 YTICS = "set ytics format  '%1.0f' 1.0  nomirror in offset 0.7,0; set mytics 2;"
 TMARGIN = "set tmargin at screen 0.96; set bmargin at screen 0.71"
 MMARGIN = "set tmargin at screen 0.63; set bmargin at screen 0.38"
 BMARGIN = "set tmargin at screen 0.30; set bmargin at screen 0.05"
 LMARGIN = "set lmargin at screen 0.20; set rmargin at screen 0.45"
 RMARGIN = "set lmargin at screen 0.50; set rmargin at screen 0.75"
 TITLE = "offset 0, -0.7"
 LCOLOR = "rgb  '#696969'"
 
 POS = "at graph -0.23,1.0 font ',18' "
 POS2 = "at graph -0.15,1.0 font ',18' "
 
 set xrange [0: 0.5]
 set yrange [0:1]
 @TMARGIN; @LMARGIN
 @XTICS; @YTICS
 #set title "k_1=0.0" @TITLE
 set xlabel "k_2" offset 0,1.6
 set ylabel "c" rotate by  0 offset 1.8,0
 set label 1 "(a)"  @POS front 
 plot "wanniercenter3D_Z2_1.dat" u 1:2 w p  pt 7  ps 0.6 lc @LCOLOR
 
 @TMARGIN; @RMARGIN
 @NOYTICS; @XTICS 
 #set title "k_1=0.5" @TITLE
 set label 1 "(b)" @POS2 front
 set xlabel "k_2" offset 0,1.6
 unset ylabel
 plot "wanniercenter3D_Z2_2.dat" u 1:2 w p  pt 7  ps 0.6 lc @LCOLOR
 
 @MMARGIN; @LMARGIN
 @YTICS; @XTICS 
 #set title "k_2=0.0" @TITLE
 set label 1 "(c)" @POS front
 set xlabel "k_1" offset 0,1.6
 set ylabel "c" rotate by  0 offset 1.8,0
 plot "wanniercenter3D_Z2_3.dat" u 1:2 w p  pt 7  ps 0.6 lc @LCOLOR
 
 @MMARGIN; @RMARGIN
 @NOYTICS; @XTICS 
 set label 1 "(d)" @POS2 front
 #set title "k_2=0.5" @TITLE
 set xlabel "k_1" offset 0,1.6
 plot "wanniercenter3D_Z2_4.dat" u 1:2 w p  pt 7  ps 0.6 lc @LCOLOR

 @BMARGIN; @LMARGIN
 @YTICS; @XTICS 
 #set title "k_3=0.0" @TITLE
 set label 1 "(e)" @POS front
 set ylabel "a" rotate by  0 offset 1.8,0
 set xlabel "k_2" offset 0,1.6
 plot "wanniercenter3D_Z2_5.dat" u 1:2 w p  pt 7  ps 0.6 lc @LCOLOR
 
 
 @BMARGIN; @RMARGIN
 @NOYTICS; @XTICS 
 #set title "k_3=0.5" @TITLE
 set label 1 "(f)" @POS2 front
 set xlabel "k_2" offset 0,1.6
 plot "wanniercenter3D_Z2_6.dat" u 1:2 w p  pt 7  ps 0.6 lc @LCOLOR

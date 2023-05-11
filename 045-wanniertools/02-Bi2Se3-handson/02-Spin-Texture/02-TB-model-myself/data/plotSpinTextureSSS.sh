#!/bin/bash
# plot Spin Texture and Surface State Spectrun 

module load gnuplot
gnuplot surfdos_l.gnu
gnuplot arc_l.gnu
gnuplot spintext_l.gnu
gnuplot surfdos_r.gnu
gnuplot arc_r.gnu
gnuplot spintext_r.gnu
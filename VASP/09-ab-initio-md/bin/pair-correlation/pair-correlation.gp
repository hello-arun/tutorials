set term png linewidth 2
set output "pair_correlation.png"

colors = "#4c265f #a82c35 #2c68fc #808080 #2fb5ab"

set title "Pair-correlation function of Si at 2000 K"
set xlabel "r (Angstrom)"
set ylabel "Pair-correlation function (1/Angstrom)"

list=system("ls -1B *.dat | sed 's/.dat//g' | sed 's/pair_correlation.//g' ")

plot for [i=1:words(list)] "pair_correlation.".word(list, i).".dat" \
  with lines lc rgb word(colors, i%5) title word(list, i)


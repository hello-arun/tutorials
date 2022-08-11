#!/bin/bash
#==========================================================#
#---  parameters to be set  -------------------------------#
ncores_per_node=32 # the number of cores per node on Shaheen
ncore_list=(32 16 8) # the list of NCORE to be tested
nodes_list=(1 2 4 8 16 32 64) # the list of the number of nodes to be tests
#----------------------------------------------------------#
printf "#=======================================================================================\n" > ncore_data.dat
printf "#%8s %8s %8s %8s %12s %12s %12s\n" kpar ncore nodes ntasks time1stloop speedup parallel >> ncore_data.dat
printf "#%8s %8s %8s %8s %12s %12s %12s\n" " " " " " " " " \(seconds\) " " efficiency >> ncore_data.dat
printf "#---------------------------------------------------------------------------------------\n" >> ncore_data.dat
#----------------------------------------------------------#
# loop over "ncore"
for ncore in ${ncore_list[@]}; do
 #
 # loop over "nodes"
 for nodes in ${nodes_list[@]}; do
  ntasks=$((nodes*ncores_per_node))
  time1stloop=$(grep LOOP: ncore_${ncore}_nodes_${nodes}/OUTCAR | head -1 | cut -d : -f 3 | awk '{print $3}')
  #
  # calculate the speedup value and the parallel efficency
  if [[ ${ncore} -eq ${ncore_list[0]} ]] && [[ ${nodes} -eq ${nodes_list[0]} ]]; then
    time_ref=${time1stloop}
    speedup=$(echo "(${time_ref})/(${time1stloop})" | bc -l)
    parallel_efficiency=$(echo "(${nodes_list[0]}*${time_ref})/(${nodes}*${time1stloop})" | bc -l)
  else
    speedup=$(echo "(${time_ref})/(${time1stloop})" | bc -l)
    parallel_efficiency=$(echo "(${nodes_list[0]}*${time_ref})/(${nodes}*${time1stloop})" | bc -l)
  fi
  printf "%8i %8i %8i %8i %12.3f %12.3f %12.3f\n" 1 $ncore $nodes $ntasks $time1stloop $speedup $parallel_efficiency >> ncore_data.dat
 done
done
printf "#=======================================================================================\n" >> ncore_data.dat
#----------------------------------------------------------#
gnuplot << theend 
set term pdfcairo font "Arial,16" size 5,5
set output 'ncore_data.pdf'
#set key autotitle columnhead
set title 'Scalability Tests (120 atoms): NCORE'
set xlabel 'Number of nodes'
set ylabel 'Speedup'
set logscale xy 2
set key center top
set grid 
plot x/${nodes_list[0]} with l lc rgb 'black' lw 1 title "Ideal", \
     "ncore_data.dat" using 3:(\$2==${ncore_list[0]}?\$6:NaN) with lp lw 2 title "NCORE=${ncore_list[0]}", \
     "ncore_data.dat" using 3:(\$2==${ncore_list[1]}?\$6:NaN) with lp lw 2 title "NCORE=${ncore_list[1]}", \
     "ncore_data.dat" using 3:(\$2==${ncore_list[2]}?\$6:NaN) with lp lw 2 title "NCORE=${ncore_list[2]}"
theend
#==========================================================#

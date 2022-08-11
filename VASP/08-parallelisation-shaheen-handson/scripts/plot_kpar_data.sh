#!/bin/bash
#==========================================================#
#---  parameters to be set  -------------------------------#
ncores_per_node=32 # the number of cores per node on Shaheen
ncore_opt=32 # optimal NCORE value determined from the previous scalability test for NCORE
nodes_1kpt=2 # number of nodes for 1 k-point determined based on the assessment of the previous scalability test for NCORE
nkpoints=18 # number of k-points obtained from OUTCAR
#----------------------------------------------------------#
printf "#=======================================================================================\n" > kpar_data.dat
printf "#%8s %8s %8s %8s %12s %12s %12s\n" kpar ncore nodes ntasks time1stloop speedup parallel >> kpar_data.dat
printf "#%8s %8s %8s %8s %12s %12s %12s\n" " " " " " " " " \(seconds\) " " efficiency >> kpar_data.dat
printf "#---------------------------------------------------------------------------------------\n" >> kpar_data.dat
#----------------------------------------------------------#
# generate a list of kpar values and remove the kpar values that are clearly not optimal
for kpar0 in $(eval echo {1..$nkpoints}); do
 kptmax=$(((nkpoints-1)/kpar0+1))
 kpar=$(((nkpoints-1)/kptmax+1))
 if [[ ${kpar} -ne ${kpar0} ]]; then 
  continue
 fi
 kpar_list+=(${kpar})
done
#----------------------------------------------------------#
# loop over "kpar"
for kpar in ${kpar_list[@]}; do
 nodes=$((kpar*nodes_1kpt))
 ntasks=$((nodes*ncores_per_node))
 time1stloop=$(grep LOOP: kpar_${kpar}_nodes_${nodes}/OUTCAR | head -1 | cut -d : -f 3 | awk '{print $3}')
 #
 # calculate the speedup value and the parallel efficency
 if [[ ${kpar} -eq ${kpar_list[0]} ]]; then
   time_ref=${time1stloop}
   speedup=$(echo "(${time_ref})/(${time1stloop})" | bc -l)
   parallel_efficiency=$(echo "(${kpar_list[0]}*${nodes_1kpt}*${time_ref})/(${nodes}*${time1stloop})" | bc -l)
 else
   speedup=$(echo "(${time_ref})/(${time1stloop})" | bc -l)
   parallel_efficiency=$(echo "(${kpar_list[0]}*${nodes_1kpt}*${time_ref})/(${nodes}*${time1stloop})" | bc -l)
 fi
 printf "%8i %8i %8i %8i %12.3f %12.3f %12.3f\n" $kpar $ncore_opt $nodes $ntasks $time1stloop $speedup $parallel_efficiency >> kpar_data.dat
done
printf "#=======================================================================================\n" >> kpar_data.dat
#----------------------------------------------------------#
gnuplot << theend 
set term pdfcairo font "Arial,16" size 5,5
set output 'kpar_data.pdf'
#set key autotitle columnhead
set title 'Scalability Tests (120 atoms): KPAR; #kpts=${nkpoints}'
set xlabel 'Number of nodes'
set ylabel 'Speedup'
set logscale xy 2
set key center top
set grid 
plot x/(${kpar_list[0]}*${nodes_1kpt}) with l lc rgb 'black' lw 1 title "Ideal", \
     "kpar_data.dat" using 3:6 with lp lw 2 title "NCORE=${ncore_opt};nodes\\\_1kpt=${nodes_1kpt}", \
     "kpar_data.dat" using 3:(\$6*0.8):1 notitle with labels
theend
#==========================================================#

#!/bin/bash

quantity="tot_charge"           #the variable in the scf file to change valeus you can name it random  to calculate without any change
values="0.00 0.02 0.04 0.06 0.08 1.00 1.02"      # when you want to calculate without any change just put any single value here
# values=$(awk ' BEGIN { for( i = 0; i <= 10 ; i+=2) {x=x" "sprintf("%0.4f",i*0.001)} print(x) }')

PREFIX=`awk '/^PREFIX/ {print $3}' base.sh` 
np=`awk '/^np/ {print $3}' base.sh` 

cd ../
mkdir -p ./postProcessing
for value in $values
do
echo $quantity\_$value >> ./postProcessing/$quantity\_list.sh
mkdir -p $quantity\_$value
awk -v value="$value" -v quantity="$quantity" '$0 ~ quantity {$3 = value} {print}' ./scf.in > ./$quantity\_$value/scf.in

cat > ./$quantity\_$value/pp.in <<EOF
&INPUTPP
outdir='./out',
plot_num = 11
filplot = "pot.out"
/
EOF

cat > ./$quantity\_$value/avg.in <<EOF
1
pot.out
1.D0
150
3
1.000000
EOF

cat > ./$quantity\_$value/runAvgPot.sh << EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=$np
#SBATCH --partition=batch
#SBATCH -J Avg_Pot
#SBATCH -o Job.%J.out
#SBATCH -e Job.%J.err
#SBATCH --time=0:15:00
#SBATCH --constraint=[cascadelake|skylake]
#run the application:

module load quantumespresso/6.6
mpirun -np \$(nproc) pw.x <scf.in> scf.out

pp.x <pp.in>   pp.out
average.x <avg.in> avg.out
(awk '/Fermi energy/ || /highest occupied/{ print "#"\$0 }' scf.out  && cat avg.dat ) > temp
mv temp avg.dat
cp avg.dat ../postProcessing/avg.$quantity\_$value.sh

EOF

cd ./$quantity\_$value
echo "$quantity\_$value" >> ../ZScripts/jobs.sh 
sbatch runAvgPot.sh >> ../ZScripts/jobs.sh
echo " " >> ../ZScripts/jobs.sh 

cd ..
done
#!/bin/bash

quantity="eamp"           #the variable in the scf file to change valeus you can name it random  to calculate without any change
values="0.000 0.001"      # when you want to calculate without any change just put any single value here
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

cat > ./$quantity\_$value/pp_pot.in <<EOF
&INPUTPP
outdir = './out',
plot_num = 11
filplot = "pot.out"
/
EOF

cat > ./$quantity\_$value/avg_pot.in <<EOF
1
pot.out
1.D0
150
3
1.000000
EOF

cat > ./$quantity\_$value/pp_chden.in <<EOF
&INPUTPP
outdir = './out',
plot_num = 0
filplot = "chden.out"
/
EOF


cat > ./$quantity\_$value/avg_chden.in <<EOF
1
chden.out
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

pp.x <pp_pot.in>   pp_pot.out
average.x <avg_pot.in> avg_pot.out

(awk '/Fermi energy/ || /highest occupied/{ print "#"\$0 }' scf.out  && cat avg.dat ) > temp
mv temp avg_pot.dat
cp avg_pot.dat ../postProcessing/avg_pot.$quantity\_$value.sh

pp.x <pp_chden.in>   pp_chden.out
average.x <avg_chden.in> avg_chden.out

cp avg.dat ../postProcessing/avg_chden.$quantity\_$value.sh
EOF

cd ./$quantity\_$value
echo "$quantity\_$value" >> ../ZScripts/jobs.sh 
sbatch runAvgPot.sh >> ../ZScripts/jobs.sh
echo " " >> ../ZScripts/jobs.sh 

cd ..
done
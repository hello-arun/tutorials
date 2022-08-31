#!/bin/bash

quantity="eamp"           #the variable in the scf file to change valeus you can name it random  to calculate without any change
values="0.0000 0.0020 0.0040 0.0060 0.0080 0.0100 0.0120 0.0140 0.0160"      # when you want to calculate without any change just put any single value here
# values=$(awk ' BEGIN { for( i = 0; i <= 4 ; i+=2) {x=x" "sprintf("%0.4f",i*0.001)} print(x) }')
nproc=4
mode="batch"

SCRIPT_DIR=$PWD
ppDir=`readlink -f ../../postProcessing`
mkdir -p $ppDir/$quantity/chden/chden
for value in $values
do
cd $SCRIPT_DIR/../../
echo $value >> $ppDir/$quantity/chden/list.sh
# mkdir -p ./$quantity/chden/$value
# awk -v value="$value" -v quantity="$quantity" '$0 ~ quantity {$3 = value} {print}' ./scf.in > ./$quantity/$value/scf.in

cat > ./$quantity/$value/charge.pp.in <<EOF
&inputpp
outdir = './out'
filplot = 'charge'
plot_num = 0
/
&plot
nfile = 1
filepp(1) = 'charge'
weight(1) = 1.0
iflag = 3
output_format = 6
fileout = 'chargeDensity.cube'
/
EOF


cat > ./$quantity/$value/runChDen.sh <<EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=$nproc
#SBATCH --partition=batch
#SBATCH -J Ch_Den
#SBATCH -o Job_chden.out
#SBATCH -e Job_chden.err
#SBATCH --time=0:30:00

#run the application:


echo $nproc
module load quantumespresso/6.6

# mpirun -np \$(nproc) pw.x <scf.in> scf.out
pp.x <charge.pp.in> charge.pp.out

cp *cube $ppDir/$quantity/chden/chden/chden_$value.cube
EOF
cd ./$quantity/$value
echo "$quantity/$value" >> $SCRIPT_DIR/jobs.sh 
sbatch runChDen.sh >> $SCRIPT_DIR/jobs.sh
echo " " >> $SCRIPT_DIR/jobs.sh 
done

echo "" >> $ppDir/$quantity/chden/list.sh
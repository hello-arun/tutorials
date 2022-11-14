#!/bin/bash

quantity="eamp"           #the variable in the scf file to change valeus you can name it random  to calculate without any change
values="0.000 0.004 0.006 0.008 0.010 0.012 0.014 0.016"      # when you want to calculate without any change just put any single value here
# values=$(awk ' BEGIN { for( i = 0; i <= 4 ; i+=2) {x=x" "sprintf("%0.4f",i*0.001)} print(x) }')
nproc=`awk '/^np/ {print $3}' base.sh` 
SCRIPT_DIR=$PWD
cd ../
mkdir -p ./postProcessing/$quantity
for value in $values
do
echo $value >> ./postProcessing/$quantity/list.sh
mkdir -p $quantity/$value
awk -v value="$value" -v quantity="$quantity" '$0 ~ quantity {$3 = value} {print}' ./scf.in > ./$quantity/$value/scf.in

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

# cat > ./$quantity/$value/chargeDiff.pp.in <<EOF
# &inputpp
# /
# &plot
# nfile = 2
# filepp(1) = 'charge.${qty}_0.000'
# filepp(2) = 'charge.${qty}_$${qty}'

# weight(1) = 1.0
# weight(2) = -1.0
# iflag = 3
# output_format = 6
# fileout = 'chargeDiff.${qty}_$${qty}.cube'
# /
# EOF
cat > ./$quantity/$value/runChDen.sh <<EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=$nproc
#SBATCH --partition=batch
#SBATCH -J Ch_Den
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=0:30:00

#run the application:


echo $nproc
module load quantumespresso/6.6

mpirun -np \$(nproc) pw.x <scf.in> scf.out
pp.x <charge.pp.in> charge.pp.out

cp charge.${qty}_$${qty} ../charge.${qty}_$${qty}
EOF
cd ./$quantity/$value
echo "$quantity/$value" >> $SCRIPT_DIR/jobs.sh 
sbatch runChDen.sh >> $SCRIPT_DIR/jobs.sh
echo " " >> $SCRIPT_DIR/jobs.sh 
cd $SCRIPT_DIR/../
done

echo "" >> ./postProcessing/$quantity/list.sh
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=8
#SBATCH --partition=batch
#SBATCH -J Job1
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=0:30:00
#run the application:
module load quantumespresso/6.6

cd ../postProcessing
quantity="eamp" #the variable in the scf file to change valeus you can name it random  to calculate without any change
ref_value=0.000
if [ -s ../${quantity}_$ref_value/charge ]; then
    for name in $(cat ${quantity}_list.sh); do
        echo "Trying for $name"
        if [ -s ../$name/charge ]; then
            echo found something
            echo creating chargeDiff.pp.in file
            cat > ./chargeDiff.pp.in <<EOF
&inputpp
/
&plot
nfile = 2
filepp(1) = '../${quantity}_${ref_value}/charge'
filepp(2) = '../${name}/charge'

weight(1) = 1.0
weight(2) = -1.0
iflag = 3
output_format = 5
fileout = 'chargeDiff.${name}.xsf'
/
EOF
            pp.x <chargeDiff.pp.in >chargeDiff.pp.out
        else
            echo not found anything
        fi
    done
else
    echo "Even reference is not available what are trying to do.."
fi

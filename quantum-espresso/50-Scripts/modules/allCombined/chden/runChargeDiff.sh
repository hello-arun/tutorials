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
quantity="eamp" #the variable in the scf file to change valeus you can value it random  to calculate without any change
ref_value=0.0000
SCRIPT_DIR=$PWD
ppDir=`readlink -f ../../postProcessing`
srcDIR=`readlink -f ../../${quantity}/`
mkdir -p $ppDir/${quantity}/chden/chDiff
cd $ppDir/${quantity}/chden/chDiff
if [ -s $srcDIR/$ref_value/charge ]; then
    for value in $(cat $ppDir/${quantity}/chden/list.sh); do
        echo "Trying for $value"
        if [ -s $srcDIR/$value/charge ]; then
            echo found something
            echo creating chargeDiff.pp.in file
            mkdir -p $ppDir/${quantity}/chden/chDiff
            cat > $ppDir/${quantity}/chden/chDiff/chargeDiff.pp.in <<EOF
&inputpp
/
&plot
nfile = 2
filepp(1) = '${srcDIR}/${ref_value}/charge'
filepp(2) = '${srcDIR}/${value}/charge'

weight(1) = -1.0
weight(2) =  1.0
iflag = 3
output_format = 6
fileout = 'chDiff_${value}.cube'
/
EOF
            pp.x <chargeDiff.pp.in >> chargeDiff.pp.out
        else
            echo not found anything
        fi
    done
else
    echo "Even reference is not available what are trying to do.."
fi

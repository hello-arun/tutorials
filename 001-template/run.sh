#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}

# Copy required files
reqFiles="INCAR-* *.UPF *.py *.sbatch"
cd "$dataDIR" || exit
cp $reqFiles "$calcDIR"/

cd $calcDIR || exit
sed -i "s/__JobName/calcName/" ${calcDIR}/run.sbatch

sbatch run.sbatch

#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}

# Copy required files
reqFiles="INCAR-* *.UPF plot-bands.py run.sbatch"
cd $dataDIR
cp $reqFiles $calcDIR/

cd $calcDIR
sed -i "s/__jObName/InSe-Band/" ${calcDIR}/run.sbatch

sbatch run.sbatch

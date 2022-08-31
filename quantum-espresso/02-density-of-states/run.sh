#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}

# Copy required files
cd $dataDIR
cp dos.in plot-dos.py INCAR-nscf.pw  INCAR-scf.pw  run.sbatch  Si.pz-vbc.UPF  $calcDIR/

cd $calcDIR
sed -i "s/__jObName/Si-DOS/" ${calcDIR}/run.sbatch

sbatch run.sbatch

#!/bin/bash
source /ibex/scratch/jangira/root/sbatchh.sh

wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}

# Copy required files
cd $dataDIR
pseudos="B_pbe_v1.01.uspp.F.UPF N.oncvpsp.upf"
cp INCAR-*.pw grep-polarization.sh ${pseudos} run.sbatch $calcDIR/

cd $calcDIR
sed -i "s/__jObName/Polar-hBN/" ${calcDIR}/run.sbatch

sbatchh run.sbatch

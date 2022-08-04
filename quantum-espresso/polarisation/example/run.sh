#!/bin/bash
source /ibex/scratch/jangira/root/sbatchh.sh

wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}

# Copy required files
cd $dataDIR
pseudos="Pb.pz-d-van.UPF Ti.pz-sp-van_ak.UPF O.pz-van_ak.UPF"
cp INCAR-*.pw  ${pseudos} run-polarization.sbatch $calcDIR/

cd $calcDIR
sed -i "s/__jobName/Polar-PbTiO3/" ${calcDIR}/run-polarization.sbatch

sbatchh run-polarization.sbatch

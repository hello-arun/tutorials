#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc/e11/grid-15x15x1
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}

cp -r ${dataDIR} run.sh ${bcupDIR}/

# Copy required files
cd $dataDIR
pseudos="*.UPF"
cp INCAR-relax.pw INCAR-nscf.pw grep-polarization.sh plot-polarization.py ${pseudos} runCalcPolarization.sbatch runSetup.sh $calcDIR/

cd $calcDIR
bash runSetup.sh

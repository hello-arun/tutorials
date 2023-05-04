#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc/e11/ww-grid-axbxc
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}

cp -r ${dataDIR} run.sh  ${bcupDIR}/

# Copy required files
cd $dataDIR
reqFiles="grep-pol.sh plot-polarization.py INCAR  KPOINTS  POSCAR  POTCAR  runCalcPolarization.sbatch  runSetup.sh"
cp $reqFiles $calcDIR/

# Some Replacements

cd $calcDIR
bash runSetup.sh
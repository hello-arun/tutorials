#!/bin/bash


wd=${PWD}
calcDIR=${wd}/calc/piezoIonClamped/e22
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}
cp -r ${dataDIR} ${wd}/run.sh ${bcupDIR}

# Copy required files
cd $dataDIR
reqFiles="grepPol.sh plotPol.py INCAR  KPOINTS  POSCAR  POTCAR runCalcPolarization-*.sbatch runSetup.sh"
cp $reqFiles $calcDIR/

# Some Replacements

cd $calcDIR
bash runSetup.sh

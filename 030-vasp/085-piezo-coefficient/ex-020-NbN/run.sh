#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc/e33
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}

# Copy required files
cd $dataDIR
reqFiles="grep-pol.sh calc-pol.sh plot-polarization.py chgcen.py INCAR  KPOINTS POTCAR  runCalcPolarization.sbatch  runSetup.sh"
cp $reqFiles $calcDIR/
cp -r POSCARS $calcDIR/

# Some Replacements
cd $calcDIR
bash runSetup.sh
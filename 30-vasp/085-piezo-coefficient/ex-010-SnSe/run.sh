#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc/e11
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}

# Copy required files
cd $dataDIR
reqFiles="grep-pol.sh plot-polarization.py INCAR  KPOINTS  POSCAR  POTCAR  runCalcPolarization.sbatch  runSetup.sh"
cp $reqFiles $calcDIR/

# Some Replacements

cd $calcDIR
bash runSetup.sh
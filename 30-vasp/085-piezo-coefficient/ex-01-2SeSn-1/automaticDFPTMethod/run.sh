#!/bin/bash


wd=${PWD}
calcDIR=${wd}/calc/piezo/allCoefsTightEdiff-IBRION7-LEPSILON
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}
cp -r ${dataDIR} ${wd}/run.sh ${bcupDIR}

# Copy required files
cd $dataDIR
reqFiles="plotPol.py INCAR  KPOINTS  POSCAR  POTCAR runCalcPol*.sbatch"
cp $reqFiles $calcDIR/

# Some Replacements
cd $calcDIR
sbatch runCalcPolShaheen.sbatch

#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc/mp-grid-15x15x1-slab-middle/
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}

cp -r ${dataDIR} run.sh  ${bcupDIR}/

# Copy required files
cd $dataDIR
reqFiles="CHGCAR INCAR  KPOINTS  POSCAR  POTCAR  run.sbatch"
cp $reqFiles $calcDIR/
cp $(cat $dataDIR/CHGCAR) $calcDIR/
# Some Replacements

cd $calcDIR
sbatch run.sbatch
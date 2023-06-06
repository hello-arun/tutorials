#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc/mp-grid-15x15x1-slab-middle-ISMEAR_-5/
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
#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc/strain-method/
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
vaspkit="~/application/vaspkit/1.4.0/vaspkit.1.4.0/bin/vaspkit"

# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}
cp -r ${dataDIR} run.sh  ${bcupDIR}/

# Copy required files
cd $dataDIR
reqFiles="INCAR  KPOINTS  POSCAR VPKIT.in POTCAR run.sbatch launchBatchJobs.sh"
cp $reqFiles $calcDIR/

# Some Replacements

cd $calcDIR
vaspkit -task 200 > run.log
bash launchBatchJobs.sh >> run.log
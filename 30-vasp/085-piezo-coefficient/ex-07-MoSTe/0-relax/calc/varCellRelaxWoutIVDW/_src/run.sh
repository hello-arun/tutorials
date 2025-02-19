#!/bin/bash
# run with [--dry or -d] for a quick dry run

wd=${PWD}
calcDIR=${wd}/calc/varCellRelaxWoutIVDW
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src

# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}
cp -r ${dataDIR} run.sh ${bcupDIR}/

# Copy required files
cd $dataDIR
cp INCAR KPOINTS POTCAR POSCAR run* $calcDIR/
# Some Replacements

cd $calcDIR
sbatch run-shaheen.sbatch


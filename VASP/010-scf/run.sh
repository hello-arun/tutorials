#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data

# make any required dirs
mkdir -p "${calcDIR}"

# Copy required files
cd "$dataDIR" || exit
reqFiles="INCAR  KPOINTS  OPTCELL  POSCAR  POTCAR  run.sbatch"
cp $reqFiles "$calcDIR"/

cd "$calcDIR" || exit
sed -i "s/__JobName/IniRelax/" ${calcDIR}/run.sbatch
sbatch run.sbatch
# run run.sbatch with [--dry or -d] for a quick dry run
# bash run.sbatch --dry


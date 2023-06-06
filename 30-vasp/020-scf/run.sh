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
sed -i "s/__JobName/5x5BN-Rlx/" ${calcDIR}/run.sbatch


# Dry run
    # bash run.sbatch
# Full run
    sbatch run.sbatch
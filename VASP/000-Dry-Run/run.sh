#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}

# Copy required files
cd $dataDIR
cp INCAR OPTCELL POSCAR POTCAR KPOINTS run.sbatch $calcDIR/

cd $calcDIR
sed -i "s/__JobName/dry-run/" "$calcDIR/run.sbatch"

# Dry run
    # Stop it after 10 to 15 seconds. 
    bash run.sbatch
# Full run
    # sbatch run.sbatch
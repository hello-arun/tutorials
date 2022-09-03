#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}

# Copy required files
cd $dataDIR
cp INCAR POSCAR POTCAR KPOINTS run.sbatch grep-k-mesh-and-res-lattice.sh plot-kmesh.py $calcDIR/

cd $calcDIR
sed -i "s/__jobName/dry-run/" "$calcDIR/run.sbatch"

# IBEX
    # sbatchh run.sbatch
# HPC
    bash run.sbatch
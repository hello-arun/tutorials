#!/bin/bash

source /ibex/scratch/jangira/root/sbatchh.sh

# Monkhrost grids
mkgrids="4x4x1 8x8x1 16x16x1 24x24x1 16x16x2 8x8x2"
wd=${PWD}
dataDIR=${wd}/data

for grid in $mkgrids; do
    job_name="${grid}"
    calcDIR=${wd}/temp/KPOINTS/${grid}
    mkdir -p ${calcDIR}

    #Copy required files
    cd $dataDIR
    cp INCAR OPTCELL POSCAR POTCAR KPOINTS run.sbatch $calcDIR/

    # Some replacements
    cd $calcDIR
    sed -i "s/__grid/${grid//x/ }/" "$calcDIR/KPOINTS"
    sed -i "s/__job_name/${job_name}/" "$calcDIR/run.sbatch"

    # Job submission
    # bash run.sbatch
    sbatchh run.sbatch
done

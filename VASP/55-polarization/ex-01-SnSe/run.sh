#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}

# Copy required files
cd $dataDIR
cp INCAR KPOINTS POSCAR POTCAR OPTCELL run.sbatch $calcDIR/
# Some Replacements
sed -i "s/__job_name/SnSe-POL/" "$calcDIR/run.sbatch"

cd $calcDIR

machine="IBEX"  # HPC or IBEX
if [[ $machine == "IBEX" ]]; then
    sbatch run.sbatch
elif [[ $machine == "HPC" ]]; then
    bash run.sbatch
fi
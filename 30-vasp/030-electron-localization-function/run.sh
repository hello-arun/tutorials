#!/bin/bash
# run with [--dry or -d] for a quick dry run

wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}

# Copy required files
cd $dataDIR
cp INCAR KPOINTS POSCAR POTCAR OPTCELL run.sbatch $calcDIR/
# Some Replacements
sed -i "s/__job_name/Si-ELF/" "$calcDIR/run.sbatch"

cd $calcDIR
machine="IBEX"  # HPC or IBEX
if [[ $machine == "IBEX" ]]; then
    sbatch run.sbatch
    echo "Launched"
elif [[ $machine == "HPC" ]]; then
    bash run.sbatch > std.out
fi


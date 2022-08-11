#!/bin/bash

# run with [--dry or -d] for a quick dry run
echo -e "#> Usage\n    run with [--dry or -d] for a quick dry run\n#<"

wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}

# Copy required files
cd $dataDIR
cp INCAR OPTCELL POSCAR POTCAR KPOINTS run.sbatch $calcDIR/

cd $calcDIR
sed -i "s/__jobName/dry-run/" "$calcDIR/run.sbatch"

# Stop it after 10 to 15 seconds. 
# run run.sbatch with [--dry or -d] for a quick dry run
if [[ $1 == "--dry" || $1 == "-d" ]]; then
    bash run.sbatch $1
else
    source /ibex/scratch/jangira/root/sbatchh.sh
    sbatchh run.sbatch
fi

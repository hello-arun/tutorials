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
cp INCAR OPTCELL POSCAR POTCAR KPOINTS chgsum.pl bader run.sbatch $calcDIR/

cd $calcDIR
# run run.sbatch with [--dry or -d] for a quick dry run
if [[ $1 == "--dry" || $1 == "-d" ]]; then
    bash run.sbatch 
else
    source /ibex/scratch/jangira/root/sbatchh.sh
    sbatchh run.sbatch
fi

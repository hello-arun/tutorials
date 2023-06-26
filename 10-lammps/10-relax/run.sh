#!/bin/bash
# run with [--dry or -d] for a quick dry run

wd=${PWD}
calcDIR=${wd}/calc/fullRelax-24x16x1
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}
cp -r $dataDIR run.sh ${bcupDIR}/

# Copy required files
cd $dataDIR
cp INCAR.lmp  Mo-Te-Cu.reaxff  POSCAR.lmp  reaxff.control  run.sbatch  $calcDIR/
# Some Replacements
sed -i "s/__jobName/fullRelax/" "$calcDIR/run.sbatch"

cd $calcDIR
machine="IBEX"  # HPC or IBEX
if [[ $machine == "IBEX" ]]; then
    sbatch run.sbatch
elif [[ $machine == "HPC" ]]; then
    bash run.sbatch > std.out
fi


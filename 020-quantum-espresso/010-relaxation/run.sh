#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc/k-grid-5x3x6
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src

# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}

cp -r "${dataDIR}" "${wd}/run.sh" ${bcupDIR}/

# Copy required files
reqFiles="INCAR-* *.UPF run.sbatch"

cd "$dataDIR" || exit
cp $reqFiles "$calcDIR"/

cd $calcDIR || exit
sed -i "s/__jobName/AlBN-rlx/" ${calcDIR}/run.sbatch

machine="IBEX"  # Run on HPC or IBEX
if [[ $machine == "IBEX" ]]; then
    sbatch run.sbatch
elif [[ $machine == "HPC" ]]; then
    bash run.sbatch > std.out
fi

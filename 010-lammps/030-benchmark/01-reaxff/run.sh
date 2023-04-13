#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc/kokkos-spread/02-N1C4G1
bcupDIR=${calcDIR}/_src
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}
cp -r $dataDIR ${wd}/run.sh $bcupDIR/

# Copy required files
reqFiles="in.reax ffield.reax data.reax run.sbatch"
(cd $dataDIR && cp $reqFiles $calcDIR/)
# Some Replacements
sed -i "s/__jobName/N1C1/" "$calcDIR/run.sbatch"

cd $calcDIR
machine="HPC"  # HPC or IBEX
if [[ $machine == "IBEX" ]]; then
    sbatch run.sbatch
elif [[ $machine == "HPC" ]]; then
    bash run.sbatch > std.out
fi
#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc/final
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}

cp -r ${dataDIR} run.sh ${bcupDIR}/

# Copy required files
reqFiles="INCAR-* *.UPF *.py *.ipynb *.sbatch"
cd "$dataDIR" || exit 1

cp $reqFiles "$calcDIR"/

cd $calcDIR || exit 1
sed -i "s/__jobName/BandBi2Se3/" ${calcDIR}/run.sbatch

machine="IBEX"  # Run on HPC or IBEX
if [[ $machine == "IBEX" ]]; then
    sbatch run.sbatch
elif [[ $machine == "HPC" ]]; then
    bash run.sbatch > std.out
fi
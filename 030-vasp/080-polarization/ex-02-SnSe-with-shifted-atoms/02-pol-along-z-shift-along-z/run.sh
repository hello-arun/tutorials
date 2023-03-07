#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}
cp $dataDIR/grep-pol.sh $dataDIR/plot-pol.ipynb ${calcDIR}/
disps="0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09"
for disp in $disps; do
    jobDIR=$calcDIR/disp-$disp/
    mkdir -p $jobDIR
    # Copy required files
    cd $dataDIR
    cp INCAR KPOINTS POTCAR OPTCELL run.sbatch grep-pol.sh $jobDIR/
    cp $dataDIR/poscars/POSCAR-$disp $jobDIR/POSCAR
    # Some Replacements
    sed -i "s/__job_name/SnSe-$disp/" "$jobDIR/run.sbatch"
    cd $jobDIR
    machine="IBEX"  # HPC or IBEX
    if [[ $machine == "IBEX" ]]; then
        sbatch run.sbatch
    elif [[ $machine == "HPC" ]]; then
        bash run.sbatch > std.out
    fi
done
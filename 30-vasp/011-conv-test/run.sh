#!/bin/bash

quantity="kgrid" 
key="__kgrid"  # put the key in the incar file as required
values="3x3x1 4x4x1 5x5x1 6x6x1 7x7x1"
machine="IBEX"

wd=${PWD}
calcDIR=${wd}/calc/${quantity}
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src

mkdir -p ${calcDIR} ${bcupDIR}

cp -r ${dataDIR} run.sh ${bcupDIR}
cp ${dataDIR}/grep-en-vs-qty.sh ${calcDIR}/

for val in ${values}; do
    jobDIR=${calcDIR}/${val}
    mkdir -p ${jobDIR}

    # Copy required files
    cd $dataDIR
    cp INCAR KPOINTS POSCAR POTCAR run.sbatch $jobDIR/
    
    # Some Replacements
    sed -i "s/__jobName/${val}/" "$jobDIR/run.sbatch"
    sed -i "s/$key/${val//x/ }/" "$jobDIR/KPOINTS"

    # Launch the Job
    cd $jobDIR
    if [[ $machine == "IBEX" ]]; then
        sbatch run.sbatch
    elif [[ $machine == "HPC" ]]; then
        bash run.sbatch > std.out
    fi
done

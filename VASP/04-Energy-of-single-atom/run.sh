#!/bin/bash

# We aim to get energy of K atom with differnt vacuums 
vacuums=$(seq 10 2 20)
wd=${PWD}
dataDIR=${wd}/data

for vac in $vacuums; do
    job_name="1K_vac-${vac}"
    calcDIR=${wd}/calc/vac-${vac}
    mkdir -p ${calcDIR}

    # Copy required files
    cd $dataDIR
    cp INCAR OPTCELL POSCAR POTCAR KPOINTS run.sbatch $calcDIR/

    # Some replacements
    cd $calcDIR
    sed -i "s/__vac/${vac}/" "$calcDIR/POSCAR"
    sed -i "s/__job_name/${job_name}/" "$calcDIR/run.sbatch"

    # Job submission
    # bash run.sbatch
    sbatch run.sbatch

done

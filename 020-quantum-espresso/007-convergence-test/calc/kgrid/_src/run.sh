#!/bin/bash

quantity="kgrid" 
key="__kgrid"  # put the key in the incar file as required
values=("5 3 6" "10 6 12" "4 3 5")

wd=${PWD}
calcDIR=${wd}/calc/${quantity}
dataDIR=${wd}/data

mkdir -p ${calcDIR}

mkdir -p $calcDIR/_src
cp -r ${dataDIR} run.sh $calcDIR/_src

for val in "${values[@]}"; do
    jobDir=${calcDIR}/${val// /x}
    mkdir -p ${jobDir}

    # Copy required files
    cd ${dataDIR}
    cp INCAR*  run.sbatch  *.UPF  $jobDir/
    
    # Some changes in the files 
    sed -i "s/${key}/${val}/" ${jobDir}/INCAR-scf.pw

    # Job Submit
    cd ${jobDir}
    sed -i "s/__jObName/${quantity}-${val}/" ${jobDir}/run.sbatch
    sbatch run.sbatch
done
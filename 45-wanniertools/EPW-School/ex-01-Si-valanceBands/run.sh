#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc/test1
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}

cp -r ${dataDIR} run.sh ${bcupDIR}/

# Copy required files
cd $dataDIR
cp -r ./* $calcDIR/

cd $calcDIR
sed -i "s/__jobName/ex01SiWan/" run.sbatch
sbatch run.sbatch

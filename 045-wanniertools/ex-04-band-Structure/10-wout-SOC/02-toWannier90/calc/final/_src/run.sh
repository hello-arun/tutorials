#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc/final
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}

cp -r ${dataDIR} run.sh ${bcupDIR}/

# Copy required files
cd $dataDIR
cp ./* $calcDIR/
cp -r $(cat $dataDIR/wfcOutRef.txt) $calcDIR/
cd $calcDIR
sbatch run.sbatch

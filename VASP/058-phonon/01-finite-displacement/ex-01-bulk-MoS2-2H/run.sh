#!/bin/bash
echo """
This programm need 'phonopy' so make sure to 
activate appropriate env for successful run.
"""
wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data

# make any required dirs
mkdir -p ${calcDIR}

# Some Replacements
cd $dataDIR
cp POSCAR INCAR POTCAR *.conf run* $calcDIR

cd $calcDIR
bash run-preprocess.sh > std-preprocess.out

# When this calculation complete
# bash run-postprocess.sh > std-postprocess.out
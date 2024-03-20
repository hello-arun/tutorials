#!/bin/bash

echo -e """
=====================
Check NIMAGES in 
INCAR
runSetup.sh
=====================
"""

wd=${PWD}
calcDIR=${wd}/calc/optimizer-fire
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}

cp -r ${dataDIR} run.sh  ${bcupDIR}/

# Copy required files
cd $dataDIR
reqFiles="INCAR  KPOINTS POSCAR-i.vasp POSCAR-f.vasp POTCAR OUTCAR-* interpolate.py runSetup.sh runNEB.sbatch"
cp $reqFiles $calcDIR/

# Some Replacements
cd $calcDIR
bash runSetup.sh
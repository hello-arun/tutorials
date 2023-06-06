#!/bin/bash

wd=${PWD}
calcDIR=${wd}/calc/e33/grid-5x3x6
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}

cp -r ${dataDIR} run.sh ${bcupDIR}/

# Copy required files
cd $dataDIR
pseudos="Al.pz-n-rrkjus_psl.0.1.UPF  B.pz-n-rrkjus_psl.0.1.UPF  N.pz-n-rrkjus_psl.0.1.UPF"
cp INCAR-relax.pw INCAR-nscf.pw grep-polarization.sh plot-polarization.py ${pseudos} runCalcPolarization.sbatch runSetup.sh $calcDIR/

cd $calcDIR
bash runSetup.sh

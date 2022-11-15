#!/bin/bash -e

srcDIR=$(pwd)
dataDIR=$srcDIR/data
calcDIR="$srcDIR/calc/"
configDIR="/ibex/scratch/jangira/lammps/prl-121-255304-2018/01-yield-stress-test/configs/"
configs="111111101111111 111111000111111 001001000100100"
temperatures="4.20"
for temperature in $temperatures; do 
tempDIR=$calcDIR/Temp-${temperature}K
mkdir -p "$tempDIR"
for config in $configs; do
    wd="${tempDIR}/${config}"
    mkdir -p "${wd}"
    cd "$dataDIR"
    cp INCAR.lmp CH.airebo run.sbatch plot-stress-strain.py ${wd}/
    cp "${configDIR}/${config}.lmp" ${wd}/POSCAR.lmp

    # replace some variables in INCAR
    sed -i "s/__Temp/$temperature/" $wd/INCAR.lmp 

    cd ${wd}
    sed -i "s/__job-name/${config}/" $wd/run.sbatch # set mass of Hydrogen
    source /ibex/scratch/jangira/root/sbatchh.sh
    sbatchh run.sbatch
    cd "$srcDIR"
done
done
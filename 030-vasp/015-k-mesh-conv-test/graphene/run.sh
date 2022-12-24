#!/bin/bash
wd=${PWD}
calcDIR=${wd}/calc
dataDIR=${wd}/data
machine="IBEX"  # HPC or IBEX

grids=("4 4 1" "8 8 1" "16 16 1" "24 24 1" "16 16 2" "8 8 2")

# for ((i=0; i < ${#grids[@]}; i++)); do
    # grid=${grids[$i]}
for grid in "${grids[@]}"; do
    newCalcDIR="${calcDIR}/grid-${grid// /x}"
    mkdir -p ${newCalcDIR}
    # Copy required files
    cd $dataDIR
    cp INCAR KPOINTS POSCAR POTCAR run.sbatch $newCalcDIR/
    
    # Some Replacements
    sed -i "s/__grid/${grid// /x}/" "$newCalcDIR/run.sbatch"
    sed -i "s/__grid/$grid/" "$newCalcDIR/KPOINTS"

    # Launch the Job
    cd $newCalcDIR
    if [[ $machine == "IBEX" ]]; then
        sbatch run.sbatch
    elif [[ $machine == "HPC" ]]; then
        bash run.sbatch > std.out
    fi
done
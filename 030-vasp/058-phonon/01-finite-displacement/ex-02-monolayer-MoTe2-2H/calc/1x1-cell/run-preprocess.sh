#!/bin/bash -e
srcDIR=$(pwd)
phonopy -d --dim="1 1 1" -c POSCAR
POSCARs=$(ls POSCAR-*)

machine="IBEX" # HPC or IBEX


for poscar in $POSCARs; do
    cd $srcDIR
    disp=${poscar/POSCAR/disp}
    calcDIR=$srcDIR/${disp}
    mkdir -p $calcDIR
    cp POTCAR KPOINTS INCAR $calcDIR
    sed "s/__job_name/MoTe2$disp/" run-scf.sbatch > $calcDIR/run-scf.sbatch 
    cp $poscar $calcDIR/POSCAR
    cd $calcDIR
    if [[ $machine == "IBEX" ]]; then
        sbatch run-scf.sbatch
    elif [[ $machine == "HPC" ]]; then
        bash run-scf.sbatch > std.out
    fi
done


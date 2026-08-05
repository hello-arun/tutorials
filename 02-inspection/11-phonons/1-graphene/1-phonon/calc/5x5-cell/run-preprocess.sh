#!/bin/bash -e
srcDIR=$(pwd)
dim="5 5 1"
sed -i "s/__DIM/${dim}/" conf-band.conf
sed -i "s/__DIM/${dim}/" conf-mesh.conf
phonopy -d --dim="5 5 1" -c POSCAR
POSCARs=$(ls POSCAR-*)

for poscar in $POSCARs; do
    cd $srcDIR
    disp=${poscar/POSCAR/disp}
    calcDIR=$srcDIR/${disp}
    mkdir -p $calcDIR
    cp $poscar $calcDIR/POSCAR
    cp POTCAR KPOINTS INCAR run-scf* $calcDIR
    sed -i "s/__job_name/Disp$disp/" $calcDIR/run-scf_remote.sbatch 
    # cd $calcDIR
    # if [[ $machine == "IBEX" ]]; then
    #     sbatch run-scf.sbatch
    # elif [[ $machine == "HPC" ]]; then
    #     bash run-scf.sbatch > std.out
    # fi
done


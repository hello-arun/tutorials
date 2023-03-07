#!/bin/bash
# Code used to get POTCAR file

machine="IBEX"  # HPC or IBEX
dataDIR=$(pwd)
if [[ $machine == "IBEX" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/ibex/scratch/jangira/qe/pseudo/
elif [[ $machine == "HPC" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/ibex/scratch/jangira/qe/pseudo
fi

echo "copying pseudo potentials"
potentials="
N.pz-n-rrkjus_psl.0.1.UPF
Al.pz-n-rrkjus_psl.0.1.UPF
B.pz-n-rrkjus_psl.0.1.UPF
"
for pp in $potentials; do 
    echo "Copying $pp"
    cp $ppDIR/$pp $dataDIR/
done
echo "All Copied"
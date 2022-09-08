#!/bin/bash
# Code used to get POTCAR file

machine="HPC"

if [[ $machine == "IBEX" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/sw/xc40cle7/vasp/pot54/potpaw_PBE
elif [[ $machine == "HPC" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/home/jangira/Documents/applications/vasp/pot-bcup/PBE/potpaw_PBE.54
fi

echo "Generating POTCAR"
cat $ppDIR/C/POTCAR > POTCAR
echo "Done!"
#!/bin/bash
# Code used to get POTCAR file

machine="IBEX"  # HPC or IBEX

if [[ $machine == "IBEX" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/sw/xc40cle7/vasp/pot/PBE/potpaw_PBE.54
elif [[ $machine == "HPC" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/home/jangira/Documents/applications/vasp/pot-bcup/PBE/potpaw_PBE.54
fi

echo "Generating POTCAR"
cat $ppDIR/B/POTCAR $ppDIR/N/POTCAR > POTCAR
echo "Done!"
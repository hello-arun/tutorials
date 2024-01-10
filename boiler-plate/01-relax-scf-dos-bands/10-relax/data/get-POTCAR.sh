#!/bin/bash
# Code used to get POTCAR file

machine="HPC"  # HPC or IBEX

if [[ $machine == "IBEX" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/sw/xc40cle7/vasp/pot/PBE/potpaw_PBE.54
elif [[ $machine == "HPC" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/home/jangira/Documents/applications/vasp/pot-bcup/PBE/potpaw_PBE.54
fi

echo "Generating POTCAR"
rm -f POTCAR
cat $ppDIR/F/POTCAR >> POTCAR
cat $ppDIR/S/POTCAR >> POTCAR
cat $ppDIR/Ga/POTCAR >> POTCAR
echo "Done!"

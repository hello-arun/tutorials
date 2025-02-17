#!/bin/bash
# Code used to get POTCAR file
machine="ibex"  # HPC or IBEX
if [[ $machine == "ibex" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/sw/xc40cle7/vasp/pot/PBE/potpaw_PBE.54
elif [[ $machine == "HPC" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/home/jangira/Documents/applications/vasp/pot-bcup/PBE/potpaw_PBE.54
elif [[ $machine == "shaheen" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/sw/ex109genoa/vasp/pot/PBE/potpaw_PBE.54
fi

echo "Generating POTCAR"
rm POTCAR
for atom in $(head -n6 POSCAR | tail -n1); do
    suffixes=("" "_sv" "_pv" "_d" "_f")
    fileFound=false
    for suffix in "${suffixes[@]}"; do
        potcarPath="$ppDIR/$atom${suffix}/POTCAR"
        if [ -f "$potcarPath" ]; then
            cat "$potcarPath" >> POTCAR
            fileFound=true
            break
        fi
    done
    if [ "$fileFound" = false ]; then
        echo "Warning: POTCAR file not found for element $atom"
    fi
done

echo "Done!"
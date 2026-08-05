#!/bin/bash
# Code used to get POTCAR file

machine="LOCAL"  # HPC or IBEX
if [[ $machine == "KAMA" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/home/rb-arun/POTCARS_VASP/potPAW.52_PBE
elif [[ $machine == "PARAMSHAKTI" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/home/mm24d005/potcars/potPAW.52_PBE/
elif [[ $machine == "LOCAL" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/home/migamma/Softwares/vasp_PseudoP/potPAW.52_PBE/
elif [[ $machine == "CNM" ]]; then
    echo "Machine is ${machine}"
    ppDIR=/opt/soft/vasp-pot/potpaw_PBE.52/
fi

echo "Generating POTCAR"
cat $ppDIR/C/POTCAR > POTCAR
# for atom in $(head -n6 POSCAR | tail -n1); do
#     suffixes=("" "_sv" "_pv" "_d" "_f")
#     fileFound=false
#     for suffix in "${suffixes[@]}"; do
#         potcarPath="$ppDIR/$atom${suffix}/POTCAR"
#         if [ -f "$potcarPath" ]; then
#             cat "$potcarPath" >> POTCAR
#             fileFound=true
#             break
#         fi
#     done
#     if [ "$fileFound" = false ]; then
#         echo "Warning: POTCAR file not found for element $atom"
#     fi
# done

# echo "Done!"

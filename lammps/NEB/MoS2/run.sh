#!/bin/bash -e
source /ibex/scratch/jangira/root/sbatchh.sh

srcDIR=$PWD
dataDIR=$srcDIR/data
calcDIR="$srcDIR/calc/NEB-1T-to-2H"

mkdir -p "${calcDIR}"
cd "$dataDIR"
cp image-0.lmp  image-1.cord  INCAR.lmp  H-S-Mo.reaxff run.sbatch "$calcDIR"/
cp plot-NEB.py energy-grep.sh "$calcDIR"/
cd "$calcDIR"
sed -i "s/__job_name/NEB-1T-2H/" run.sbatch
sbatchh run.sbatch
cd "$srcDIR"

# supercells="24-16" # format sx-sy ; ex "30-30 40-40 50-50"
# temps="150 200 250 "

# for supercell in $supercells; do
#     IFS="-" read -r -a scales <<<"$supercell"
#     scaleX=${scales[0]}
#     scaleY=${scales[1]}
#     supercellDIR="${calcDIR}/X-${scaleX}_Y-${scaleY}"
#     mkdir -p "${supercellDIR}"
#     for temp in $temps; do
#         wd="$supercellDIR/Temp_$temp" # Temperature Director
#         mkdir -p "${wd}"
#         cd "$dataDIR"
#         cp plot-toten-per-atom.py "$wd"/

#         cp INCAR.lmp Mo-Te-Cu.reaxff reaxff.control run.sbatch "$wd"
#         cp plot-stress-strain-local.py "$wd"/plot-stress-strain.py

#         # Generate Hydrogenated POSCAR
#         python ./gen-POSCAR.py "$dataDIR"/POSCAR.lmp "0" "${scaleX}" "${scaleY}" "$wd"/POSCAR.lmp

#         cd "$srcDIR"
#         # format script files to change temperature
#         sed -i "s/__temp/$temp/" "$wd"/INCAR.lmp

#         # Change thickness based on 6.1+H%*2*1.4
#         thickness=$(echo "8.2" | bc -lq)
#         sed -i "s/__thickness/$thickness/" "$wd"/INCAR.lmp

#         cd "$wd"
#         echo "launching script from $wd"
#         # ./plot-stress-strain.py
#         sed -i "s/__job_name/T${temp}/" run.sbatch
#         sbatchh run.sbatch
#         echo "finished  script from $wd"
#         cd "$srcDIR"
#     done
# done

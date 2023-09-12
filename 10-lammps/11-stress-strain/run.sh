#!/bin/bash -e
srcDIR=$PWD
system="1T-MoTe2"
dataDIR=$srcDIR/data
calcDIR="$srcDIR/calc"
supercells="24-16" # format sx-sy ; ex "30-30 40-40 50-50"
temps="300"

for supercell in $supercells; do
    IFS="-" read -r -a scales <<<"$supercell"
    scaleX=${scales[0]}
    scaleY=${scales[1]}
    supercellDIR="${calcDIR}/X-${scaleX}_Y-${scaleY}"
    mkdir -p "${supercellDIR}"
    for temp in $temps; do
        wd="$supercellDIR/Temp_$temp" # Temperature Director
        mkdir -p "${wd}"

        cd "$dataDIR"
        cp INCAR.lmp Mo-Te-Cu.reaxff reaxff.control run.sbatch plot-stress-strain.py plot-toten-per-atom.py ${wd}/
        # generate super-cell POSCAR
        python ./gen-POSCAR.py "${dataDIR}/POSCAR.lmp" "0" ${scaleX} ${scaleY} "${wd}/POSCAR.lmp"

        # replace some variables in INCAR
        sed -i "s/__temp/$temp/" ${wd}/INCAR.lmp
        sed -i "s/__thickness/7.2/" ${wd}/INCAR.lmp

        cd ${wd}
        sbatch -J ${system} run.sbatch
        cd "$srcDIR"
    done
done

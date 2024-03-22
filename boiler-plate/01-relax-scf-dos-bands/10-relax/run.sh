#!/bin/bash

machine="SHAHEEN"  # HPC or IBEX or SHAHEEN
jobName="fullRelax"

calcDIR=${PWD}/calc/${jobName}
dataDIR=${PWD}/data
bcupDIR=${calcDIR}/_src

# make any required dirs
mkdir -p "${calcDIR}" "${bcupDIR}"
cp -r "$dataDIR" run.sh "${bcupDIR}/"

cd "$dataDIR" || exit 1
cp INCAR KPOINTS POSCAR POTCAR OPTCELL run*.sbatch "${calcDIR}/"


cd "${calcDIR}" || exit 1
if [[ $machine == "IBEX" ]]; then
    sed -i "s/__jobName/${jobName}/" run-IBEX.sbatch
    sbatch run-IBEX.sbatch
elif [[ $machine == "HPC" ]]; then
    bash run-HPC.sbatch > std.out
elif [[ $machine == "SHAHEEN" ]]; then
    sed -i "s/__jobName/${jobName}/" run-SHAHEEN.sbatch
    sbatch run-SHAHEEN.sbatch
fi

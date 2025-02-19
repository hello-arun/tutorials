#!/bin/bash
strainAxis=Y # x or y
strainValues=$(seq -0.005 0.001 0.005)

echo "Strain axis: ${strainAxis^^}"
echo "Strain vals: ${strainValues}"
wd=${PWD}
calcDIR=${wd}/calc/piezo/strain${strainAxis^^}
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src

# make required dirs
mkdir -p "${calcDIR}" "${bcupDIR}" || { echo "Failed to create directories ${calcDIR} ${bcupDIR}"; exit 1; }

# Bacup inputs
cp -r "${dataDIR}" "${wd}/run.sh" "${bcupDIR}/"  || { echo "Error: Failed to backup data and scripts"; exit 1; }


# Copy required files
cd $dataDIR || { echo "Data directory missing"; exit 1; }
reqFiles="grepPol.sh plotPol.py INCAR KPOINTS  POSCAR  POTCAR runCalcPol*.sbatch runSetup.sh"
for file in $reqFiles; do
    cp "$file" "$calcDIR/" || { echo "Failed to copy $file"; exit 1; }
done

# Some Replacements

cd $calcDIR || { echo "Failed to go to calcDIR $calcDIR"; exit 1; }
bash runSetup.sh "${strainAxis}" "${strainValues}" || { echo "Error: runSetup.sh encountered an error"; exit 1; }
echo "Setup successful."

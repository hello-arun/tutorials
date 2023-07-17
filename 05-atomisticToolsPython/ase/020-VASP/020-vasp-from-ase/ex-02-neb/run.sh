wd=${PWD}
calcDIR=${wd}/calc/climbImageBFGS-ncore-4-production
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}
cp -r $dataDIR run.sh ${bcupDIR}/
# Copy required files
cd $dataDIR
cp POSCAR*.vasp runVasp.py runVasp.sbatch $calcDIR/

# Some Replacements
# sed -i "s/__jobName/scfFulRelaxed/" "$calcDIR/run.sbatch"

cd $calcDIR
machine="IBEX"  # HPC or IBEX
if [[ $machine == "IBEX" ]]; then
    sbatch runVasp.sbatch
elif [[ $machine == "HPC" ]]; then
    bash runVasp.sh
fi
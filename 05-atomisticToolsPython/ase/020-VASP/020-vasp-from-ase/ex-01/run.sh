wd=${PWD}
calcDIR=${wd}/calc/test1
dataDIR=${wd}/data
bcupDIR=${calcDIR}/_src
# make any required dirs
mkdir -p ${calcDIR} ${bcupDIR}
cp -r $dataDIR run.sh ${bcupDIR}/
# Copy required files
cd $dataDIR
cp runVasp.py runVasp.sh $calcDIR/

# Some Replacements
# sed -i "s/__jobName/scfFulRelaxed/" "$calcDIR/run.sbatch"

cd $calcDIR
machine="IBEX"  # HPC or IBEX
if [[ $machine == "IBEX" ]]; then
    bash runVasp.sh
elif [[ $machine == "HPC" ]]; then
    bash runVasp.sh
fi
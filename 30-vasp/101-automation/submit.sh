#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jobName"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=40
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --constraint="intel"
##SBATCH --exclusive

module load intel/2020
module load openmpi/4.0.3_intel


export SLURM_NTASKS=$((SLURM_NNODES*SLURM_NTASKS_PER_NODE))
export VASP_HOME="/sw/csis/vasp/5.4.4/ompi400-intel18/vasp.5.4.4/bin"
# export VASP_CMD="mpirun -np ${SLURM_NTASKS} ${VASP_HOME}/vasp_std" # For Production
export VASP_CMD="sleep 20" # For Testing

srcDIR=${PWD}
refDIR="${srcDIR}/_ref"
relaxDIR="${srcDIR}/10-relax"
scfDIR="${srcDIR}/11-scf"
dosDIR="${srcDIR}/12-dos"
bandsDIR="${srcDIR}/13-bands"

# Make Directories
mkdir -p $relaxDIR $scfDIR $dosDIR $bandsDIR

# 10-relax
# Copy Files
cp $refDIR/INCAR-relax $relaxDIR/INCAR
cp $refDIR/KPOINTS-scf $relaxDIR/KPOINTS
cp $refDIR/POTCAR $relaxDIR/POTCAR
cp $refDIR/POSCAR $relaxDIR/POSCAR

cd $relaxDIR || exit 1
${VASP_CMD}

idx=1
while ! grep -q "reached required accuracy" OUTCAR; do
    echo -e "\n\n\n Redoing Relax Calculation"
    cp XDATCAR XDATCAR-${idx}
    cp CONTCAR POSCAR
    idx=$((idx+1))
    ${VASP_CMD}
done

echo -e "\n\n\nRelaxation Completed.. Now Jumping to SCF"

# 10-scf
# Copy Files
cd $scfDIR
cp ${relaxDIR}/CONTCAR ${scfDIR}/POSCAR
cp ${refDIR}/INCAR-scf ${scfDIR}/INCAR
cp ${refDIR}/KPOINTS-scf ${scfDIR}/KPOINTS
cp ${refDIR}/POTCAR ${scfDIR}/POTCAR
${VASP_CMD}
echo -e "\n\n\nSCF Completed.. Now Jumping to DOS"

# 11-DOS
cd $dosDIR
cp $relaxDIR/CONTCAR ${dosDIR}/POSCAR
cp $refDIR/INCAR-dos ${dosDIR}/INCAR
cp $refDIR/KPOINTS-dos ${dosDIR}/KPOINTS
cp $refDIR/POTCAR ${dosDIR}/POTCAR
cp $scfDIR/CHGCAR ${dosDIR}/CHGCAR
${VASP_CMD}
echo -e "\n\n\nDOS Completed.. Now Jumping to BANDS"

# 11-DOS
cd $bandsDIR
cp $relaxDIR/CONTCAR ${bandsDIR}/POSCAR
cp $refDIR/INCAR-bands ${bandsDIR}/INCAR
cp $refDIR/KPOINTS-bands ${bandsDIR}/KPOINTS
cp $refDIR/POTCAR ${bandsDIR}/POTCAR
cp $dosDIR/CHGCAR ${bandsDIR}/CHGCAR
${VASP_CMD}
echo -e "\n\n\nEverything Completed...Now Enjoy"

#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jobName"
#SBATCH --constraint="intel"
#SBATCH --nodes=1
#SBATCH --time=1:00:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
#SBATCH --ntasks-per-node=40
##SBATCH --exclusive

module load intel/2022.3              # module load intel/2016
module load openmpi/4.1.4/intel2022.3 # module load openmpi/4.0.3_intel
module load vasp/5.4.4                
# export VASP_HOME=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin
export OMP_NUM_THREADS=1
export SLURM_NTASKS=$((SLURM_NNODES*SLURM_NTASKS_PER_NODE))
echo """
                MACHINE: IBEX
           SLURM_JOB_ID: ${SLURM_JOB_ID}
     SLURM_JOB_NODELIST: ${SLURM_JOB_NODELIST}
           SLURM_NNODES: ${SLURM_NNODES}
           SLURM_NTASKS: ${SLURM_NTASKS}
           SLURM_NPROCS: ${SLURM_NPROCS}
  SLURM_NTASKS_PER_CORE: ${SLURM_NTASKS_PER_CORE}
   SLURM_NTASKS_PER_GPU: ${SLURM_NTASKS_PER_GPU}
  SLURM_NTASKS_PER_NODE: ${SLURM_NTASKS_PER_NODE}
SLURM_NTASKS_PER_SOCKET: ${SLURM_NTASKS_PER_SOCKET}
"""

VASP_CMD="mpirun -np ${SLURM_NTASKS} ${VASP_HOME}/vasp_std"  # For Standard Calc
# VASP_CMD="mpirun -np ${SLURM_NTASKS} ${VASP_HOME}/vasp_ncl"  # For Spin Orbit Coupling

if [ -f "CONTCAR" ]; then
  echo "=========================================="
  echo "CONTCAR exist. Copying it."
  cp CONTCAR POSCAR
fi 

echo "=========================================="
echo "Doing a SCF run without dipole correction."
sed \
-e "s/__NSW/0/" \
-e "s/__ISTART/0/" \
-e "s/__ICHARG/2/" \
-e "s/__LDIPOL/False/" INCAR-base > INCAR
cp CHGCAR CHGCAR-noDIPOL
cp WAVECAR WAVECAR-noDIPOL
${VASP_CMD}

idx=1
while ! grep -q "reached required accuracy" OUTCAR; do
  echo "=========================================="
  echo "Accuracy not reached yet. Doing Relax Calculation."
  cp CONTCAR POSCAR
  cp XDATCAR XDATCAR-${idx}
  cp OUTCAR OUTCAR-${idx}
  ((idx++))
  sed \
  -e "s/__NSW/50/" \
  -e "s/__ISTART/1/" \
  -e "s/__ICHARG/1/" \
  -e "s/__LDIPOL/True/" INCAR-base > INCAR
  ${VASP_CMD}
done

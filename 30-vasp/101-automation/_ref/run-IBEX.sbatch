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

module load intel/2016
module load openmpi/4.0.3_intel
export VASP_HOME=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin
export OMP_NUM_THREADS=1
export SLURM_NTASKS=$((SLURM_NNODES*SLURM_NTASKS_PER_NODE))

echo """
                MACHINE: IBEX
           SLURM_NODEID: ${SLURM_NODEID}
         SLURM_NODELIST: ${SLURM_NODELIST}
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

if [ -e CONTCAR ]; then
  echo "CONTCAR exists. Doing Relax Calculation with LDIPOL=True"
  sed \
  -e "s/__NSW/100/" \
  -e "s/__LDIPOL/True/" INCAR-base > INCAR
  ${VASP_CMD}
else
  echo "CONTCAR Does not exists. Doing single SCF LDIPOL=False"
  sed \
  -e "s/__NSW/0/" \
  -e "s/__LDIPOL/False/" INCAR-base > INCAR
  ${VASP_CMD}
  cp CHGCAR CHGCAR-noDIPOL
  cp WAVECAR WAVECAR-noDIPOL

  echo -e "\n\n\n\n\n SCF Complete. Doing Relax with LDIPOL=True"
  sed \
  -e "s/__NSW/100/" \
  -e "s/__LDIPOL/True/" INCAR-base > INCAR
  ${VASP_CMD}
fi

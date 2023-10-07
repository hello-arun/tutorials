#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jobName"
#SBATCH --constraint="amd"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --time=2:30:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
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

mpirun -np ${SLURM_NTASKS} ${VASP_HOME}/vasp_std    # For Standard Calc
# mpirun -np ${SLURM_NTASKS} ${VASP_HOME}/vasp_ncl    # For Spin Orbit Coupling

#!/bin/bash

# Test with care and HPC vasp is not compiled
# with constrained relaxation functionality
module load intel-mkl/2020.0.166/intel-19.1.0.166-wxnxb2u
module load openmpi/3.1.5/intel-19.1.0.166-6slj4uh
export VASP_CMD=/home/jangira/Documents/applications/vasp/bin/vasp_std
export OMP_NUM_THREADS=1
SLURM_NTASKS=24

echo """
                MACHINE: HPC
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

cp $(cat chgcarRef) ./
mpirun -np ${SLURM_NTASKS} ${VASP_CMD}

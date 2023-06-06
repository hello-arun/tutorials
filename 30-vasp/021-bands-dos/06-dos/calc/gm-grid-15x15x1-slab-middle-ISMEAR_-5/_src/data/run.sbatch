#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="DOS"
##SBATCH --constraint=amd
##SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --time=0:30:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
## SBATCH --exclusive

srcDIR=$(pwd)
module load intel/2016
module load openmpi/4.0.3_intel
export VASP_CMD=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin/vasp_std
export OMP_NUM_THREADS=1

echo """
       JobId: ${SLURM_JOB_ID}
    NodeList: ${SLURM_JOB_NODELIST}
"""

mpirun -np ${SLURM_NPROCS} ${VASP_CMD}


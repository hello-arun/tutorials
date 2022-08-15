#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__job_name"
#SBATCH --constraint=intel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=1:00:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive

# On Ibex
    module load intel/2016
    module load openmpi/4.0.3_intel
    export VASP_CMD=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin/vasp_gam
    export OMP_NUM_THREADS=1

# On Local HPC
    ##---------Not Yet Implmented---------##

mpirun -np ${SLURM_NPROCS} ${VASP_CMD}

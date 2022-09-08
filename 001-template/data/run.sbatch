#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="=__JobName"
#SBATCH --constraint=intel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=0:30:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive

# On IBEX
    # module load quantumespresso/6.6

# On Local HPC
    # module load quantum-espresso/6.4.1/intel-19.1.0.166-mkl-openmpi-m2l27zt  
    # SLURM_NPROCS=24

# Calculation Starts Here

mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-bands.pw > OUTCAR-bands.pw


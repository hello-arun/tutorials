#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jobName"
#SBATCH --constraint=intel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=1:00:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive
module load quantumespresso/6.6

# Initial SCF run 
mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-scf.pw > OUTCAR-scf.pw

# NSCF run for berry phase
mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-nscf.pw > OUTCAR-nscf.pw
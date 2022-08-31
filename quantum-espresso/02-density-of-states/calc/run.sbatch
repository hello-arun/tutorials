#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="Si-DOS"
#SBATCH --constraint=intel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=0:20:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive

# On IBEX
    module load quantumespresso/6.6

# On Local HPC
    # module load quantum-espresso/6.4.1/intel-19.1.0.166-mkl-openmpi-m2l27zt  
    # SLURM_NPROCS=24

# SCF run Initial 
mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-scf.pw > OUTCAR-scf.pw

# NSCF run for dos
mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-nscf.pw > OUTCAR-nscf.pw

# Dos.x post Processing
mpirun -np 1 dos.x -i si_dos.in > dos.out
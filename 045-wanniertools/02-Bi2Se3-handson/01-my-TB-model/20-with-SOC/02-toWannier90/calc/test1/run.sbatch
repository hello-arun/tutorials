#!/bin/bash
#SBATCH --partition=debug
#SBATCH --job-name="Bi2Se3TB"
#SBATCH --constraint=intel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=0:30:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive

# On IBEX
    module load wannier90/3.0.0/openmpi-3.0.0-intel2017
    module load quantumespresso/6.6

# On Local HPC
    # module load quantum-espresso/6.4.1/intel-19.1.0.166-mkl-openmpi-m2l27zt  
    # export SLURM_NPROCS=2

# Initial relaxation and scf 
# echo "Doing SCF"
#     mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-scf.pw > OUTCAR-scf.pw
#     echo "  Done SCF"

# echo "Doing NSCF"
#     mpirun -np ${SLURM_NPROCS} pw.x -i 04-nscf.in > 04-nscf.out
#     echo "  Done NSCF"

echo "Preparing some stuff for wannier90.x"
    mpirun -np ${SLURM_NPROCS} wannier90.x -pp 10-wannier90
    echo "  Done preparing some stuff for wannier90.x"

# echo "Doing Projectino Wave Functions"
#     mpirun -np ${SLURM_NPROCS} projwfc.x  -i 05-projwfc.in > 05-projwfc.out
#     echo "  Done"

echo "Converting pwscf to wannier90"
    mpirun -np ${SLURM_NPROCS} pw2wannier90.x -in 06-pw2wan.in > 06-pw2wan.out
    echo "  Convered pwscf to wannier90"

echo "Final wannier90 run"
    mpirun -np ${SLURM_NPROCS} wannier90.x 10-wannier90
    echo "  Done Tata!!!"
# Check if convergence is achieved
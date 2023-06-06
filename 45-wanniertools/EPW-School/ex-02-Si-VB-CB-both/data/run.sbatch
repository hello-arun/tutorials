#!/bin/bash
#SBATCH --partition=debug
#SBATCH --job-name="__jobName"
#SBATCH --constraint=[intel|amd]
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
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
echo "Doing SCF"
    mpirun -np ${SLURM_NPROCS} pw.x -i 01_scf.in > 01_scf.out
    echo "  Done SCF"

echo "Doing NSCF Bands"
    mpirun -np ${SLURM_NPROCS} pw.x -i 02_bands.in > 02_bands.out
    echo "  Done NSCF Bands"

echo "Extracting Bands to Plot"
    mpirun -np ${SLURM_NPROCS} bands.x -i 03_bandsx.in > 03_bandsx.out
    echo "  Done"

echo "Doing NSCF Bands"
    mpirun -np ${SLURM_NPROCS} pw.x -i 05_nscf.in > 05_nscf.out
    echo "  Done NSCF Bands"


echo "Preparing some stuff for wannier90.x"
    mpirun -np ${SLURM_NPROCS} wannier90.x -pp ex2
    echo "  Done preparing some stuff for wannier90.x"

echo "Converting pwscf to wannier90"
    mpirun -np ${SLURM_NPROCS} pw2wannier90.x -in 06_pw2wan.in > 06_pw2wan.out
    echo "  Convered pwscf to wannier90"

echo "Final wannier90 run"
    mpirun -np ${SLURM_NPROCS} wannier90.x ex2
    echo "  Done Tata!!!"
# Check if convergence is achieved
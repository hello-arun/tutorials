#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jobName"
#SBATCH --constraint=[intel|amd]
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time=0:30:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std-%j.err
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
    mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-scf.pw > OUTCAR-scf.pw
    echo "  Done SCF"

echo "Doing NSCF"
    mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-nscf.pw > OUTCAR-nscf.pw
    echo "  Done NSCF"

echo "Preparing some stuff for wannier90.x"
    mpirun -np ${SLURM_NPROCS} wannier90.x -pp INCAR
    echo "  Done preparing some stuff for wannier90.x"

echo "Converting pwscf to wannier90"
    mpirun -np ${SLURM_NPROCS} pw2wannier90.x -in INCAR.pw2wan > OUTCAR.pw2wan
    echo "  Convered pwscf to wannier90"

echo "Final wannier90 run"
    mpirun -np ${SLURM_NPROCS} wannier90.x INCAR
    echo "  Done Tata!!!"
# Check if convergence is achieved
#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="DRY-RUN"
#SBATCH --constraint=intel
#SBATCH -N 16
#SBATCH --ntasks-per-node=24
#SBATCH --time=4:00:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive

# IBEX
    # module load intel/2016
    # module load openmpi/4.0.3_intel
    # export VASP_HOME=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin/vasp_std
    # export OMP_NUM_THREADS=1
# LOCAL HPC
    module load vasp
    export VASP_HOME=vasp
    SLURM_NPROCS=24

mpirun -np ${SLURM_NPROCS} ${VASP_HOME} > std.out
rm DOSCAR EIGENVAL OSZICAR PCDAT CHG* WAVECAR XDATCAR REPORT CONTCAR vasprun.xml
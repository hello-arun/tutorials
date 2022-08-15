#!/bin/bash
#SBATCH -N 8
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH -o std.out
#SBATCH -e std.err
#SBATCH --time=5:00:00
#SBATCH --constraint=intel
#SBATCH --mail-type=ALL

#run the application:
module load openmpi/4.0.3
module load gcc/11.1.0
lmp_ibex="/ibex/scratch/jangira/lammps/sw/lammps-16Feb2016/openmpi/4.0.3/gcc/11.1.0/src/lmp_mpi"
export OMP_NUM_THREADS=1

mpirun -np ${SLURM_NPROCS} ${lmp_ibex} -in INCAR.lmp

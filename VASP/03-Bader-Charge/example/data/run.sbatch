#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="2H-MoS2-relax"
#SBATCH --constraint=intel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=4:00:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive

module load intel/2016
module load openmpi/4.0.3_intel
export VASP_HOME=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin
export OMP_NUM_THREADS=1

mpirun -np ${SLURM_NPROCS} ${VASP_HOME}/vasp_std

module load perl
perl chgsum.pl AECCAR0 AECCAR2
# The total charge will be written to `CHGCAR_sum`.
# The bader analysis can then be done on this total charge density file:

chmod +x bader
bader CHGCAR -ref CHGCAR_sum

module purge 
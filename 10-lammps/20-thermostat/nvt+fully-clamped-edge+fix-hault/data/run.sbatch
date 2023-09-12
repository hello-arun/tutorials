#!/bin/bash
#SBATCH -N 8
#SBATCH --job-name="__job-name"
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH -o std.out
#SBATCH -e std.err
#SBATCH --time=2:00:00
#SBATCH --constraint=intel
#SBATCH --mail-type=ALL

#run the application:
module load lammps/29Sep2021/openmpi-4.0.3_intel2020
# module load openmpi/4.0.3
# module load gcc/11.1.0
lmp_ibex="/sw/csi/lammps/29Sep2021/openmpi-4.0.3_intel2020/install/bin/lmp_ibex"
export OMP_NUM_THREADS=1

mpirun -np ${SLURM_NPROCS} ${lmp_ibex} -in INCAR.lmp

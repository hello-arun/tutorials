#!/bin/bash
#SBATCH -N 4
#SBATCH --job-name="__job_name"
#SBATCH --ntasks-per-node=28
#SBATCH --partition=batch
#SBATCH --constraint=[intel|amd]
#SBATCH -o std.out
#SBATCH -e std.err
#SBATCH --time=1:00:00
#run the application:

module load intel/2020
module load openmpi/4.0.3_intel
module load  lammps/29Sep2021/openmpi-4.0.3_intel2020
lmp_ibex=/sw/csi/lammps/29Sep2021/openmpi-4.0.3_intel2020/install/bin/lmp_ibex
export OMP_NUM_THREADS=1

mpirun -np ${SLURM_NPROCS} --oversubscribe ${lmp_ibex} -partition 7x16 -in INCAR.lmp
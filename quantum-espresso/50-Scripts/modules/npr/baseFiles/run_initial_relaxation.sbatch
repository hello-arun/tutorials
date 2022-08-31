#!/bin/bash -e
#SBATCH -N 1
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH -J PR0
#SBATCH -o std.out
#SBATCH -e std_%j.err
#SBATCH --time=2:00:00
#SBATCH --constraint="intel"

#loading modules:
module load quantumespresso/6.6
axis=$1
strains=$2
scriptDIR=$PWD
cd ../
mpirun -np ${SLURM_NPROCS} pw.x <relax.in> relax.out
cd $scriptDIR
./run_batch_relaxation.sh $1 "$2"

#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH -J Opt
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=2:00:00
#SBATCH --constraint="[skylake|cascadelake]"

#run the application:

SCRIPT_DIR=$PWD
cd ../
module load quantumespresso/6.6


mpirun -np $(nproc) pw.x <relax.in> relax.out
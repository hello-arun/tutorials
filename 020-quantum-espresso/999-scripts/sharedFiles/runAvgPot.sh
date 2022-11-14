#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH -J Job1
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=0:5:00

#run the application:

SRC_DIR=`awk '/folder/ {print $3}' base.sh`
PREFIX=`awk '/PREFIX/ {print $3}' base.sh`
cd ../
SRC_DIR=$PWD

module load quantumespresso/6.6
mpirun -np $(nproc) pw.x <$PREFIX.scf.in> $PREFIX.scf.out

pp.x <$PREFIX.pp.in> $PREFIX.pp.out
pp.x <$PREFIX.pp.in> $PREFIX.pp.out
average.x <$PREFIX.avg.in> $PREFIX.avg.out


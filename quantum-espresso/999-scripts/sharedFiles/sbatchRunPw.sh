#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH -J Job1
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=1:30:00
#SBATCH --constraint=[cascadelake|skylake]

PREFIX=`awk '/PREFIX/ {print $3}' ../base.sh`

module load quantumespresso/6.6

for command in scf relax bands
do
mpirun -np $(nproc) pw.x <GeS.$command.in> GeS.$command.out
done


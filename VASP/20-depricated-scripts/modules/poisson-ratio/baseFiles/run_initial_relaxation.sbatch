#!/bin/bash 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH --constraint="intel"
#SBATCH --job-name=0.0
#SBATCH --output=std.out
#SBATCH --error=std_%j.err
#SBATCH --time=2:00:00
#SBATCH --mail-user=arun.jangir@kaust.edu.sa
#SBATCH --mail-type=ALL

#loading modules:
module load intel/2016
module load openmpi/4.0.3_intel
export VASP_HOME=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin

echo -e "
Job id : ${SLURM_JOB_ID}
Cores  : ${SLURM_NPROCS}
Nodes  : ${SLURM_JOB_NODELIST}
"

axis=$1
strains=$2
scriptDIR=$PWD
cd ../
mpirun -np ${SLURM_NPROCS} ${VASP_HOME}/vasp_std
cd $scriptDIR
./run_batch_relaxation.sh $1 "$2"

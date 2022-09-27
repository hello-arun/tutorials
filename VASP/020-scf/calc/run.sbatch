#!/bin/bash -e
#SBATCH --job-name=5x5BN-Rlx
#SBATCH --nodes=12
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH --constraint="intel"
#SBATCH --output=std.out
#SBATCH --error=std.err
#SBATCH --time=1:00:00
#SBATCH --mail-user=arun.jangir@kaust.edu.sa
#SBATCH --mail-type=ALL

# IBEX
    module load intel/2016
    module load openmpi/4.0.3_intel
    export VASP_HOME=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin/vasp_std
    export OMP_NUM_THREADS=1
# LOCAL HPC
    # module load vasp
    # export VASP_HOME=vasp
    # SLURM_NPROCS=24

echo -e "
Job id : ${SLURM_JOB_ID}
Cores  : ${SLURM_NPROCS}
Nodes  : ${SLURM_JOB_NODELIST}
"
mpirun -np ${SLURM_NPROCS} ${VASP_HOME}
#!/bin/bash
#...........................
#SBATCH -N 1
#SBATCH --ntasks-per-node=128
#SBATCH --partition=debug
#SBATCH -J per1
#SBATCH -o std.out
#SBATCH -e std.err
#SBATCH --mail-type=ALL
#SBATCH --time=02:00:00
#SBATCH --mem=260G
#SBATCH --constraint="amd"
export OMP_NUM_THREADS=1
export MKL_DEBUG_CPU_TYPE=5
#...........................
nos=128

module purge; sleep 10s; module load intel/2022.3 openmpi/4.1.4/intel2022.3 vasp/5.4.4

#..
touch WAVECAR CHGCAR

echo "The job "${SLURM_JOB_ID}" is running on "${SLURM_JOB_NODELIST}
mpirun --bind-to core --map-by core -np ${nos} ${VASP_HOME}/vasp_std

#..
echo "Calculation Completed."
echo "Let\'s hope it worked"

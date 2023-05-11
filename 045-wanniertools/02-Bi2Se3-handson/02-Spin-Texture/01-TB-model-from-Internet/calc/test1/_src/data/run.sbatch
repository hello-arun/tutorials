#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jobName"
#SBATCH --constraint=[intel|amd]
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time=0:30:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std-%j.err
#SBATCH --output=./std.out
##SBATCH --exclusive

# On IBEX
    module purge
    module load intelmpi/2020
    module load wanniertools/2.5.1/impi2020-intel2020
    module load gnuplot
# On Local HPC
    # module load quantum-espresso/6.4.1/intel-19.1.0.166-mkl-openmpi-m2l27zt  
    # export SLURM_NPROCS=2

# Initial relaxation and scf 
echo "Running Wannier Tools"
    mpirun -np ${SLURM_NPROCS} wt.x 
    echo "  Done"

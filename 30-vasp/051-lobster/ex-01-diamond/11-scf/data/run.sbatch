#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jobName"
#SBATCH --constraint=[intel|amd]
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time=0:30:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive

machine="IBEX" # HPC or IBEX
if [[ $machine == "IBEX" ]]; then
    module load intel/2016
    module load openmpi/4.0.3_intel
    export VASP_CMD=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin/vasp_std
    export LOBSTER_CMD=/home/jangira/Documents/applications/lobster/v4.1.0/lobster
    export OMP_NUM_THREADS=1
elif [[ $machine == "HPC" ]]; then
    # Test with care and HPC vasp is not compiled
    # with constrained relaxation functionality
    module load intel-mkl/2020.0.166/intel-19.1.0.166-wxnxb2u
    module load openmpi/3.1.5/intel-19.1.0.166-6slj4uh
    export VASP_CMD=/home/jangira/Documents/applications/vasp/bin/vasp_std
    export OMP_NUM_THREADS=1
    SLURM_NPROCS=24
fi

echo "Doing SCF"
mpirun -np ${SLURM_NPROCS} ${VASP_CMD}

echo -e "SCF Completed\n\nNow Doing LOBSTER\n"

${LOBSTER_CMD} 

echo "All Done! Exit now"
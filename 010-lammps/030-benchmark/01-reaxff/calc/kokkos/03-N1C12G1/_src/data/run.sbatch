#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jobName"
#SBATCH --constraint=intel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=1:00:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std-%j.err
#SBATCH --output=./std.out
##SBATCH --exclusive

srcDIR=$(pwd)
machine="HPC" # HPC or IBEX
if [[ $machine == "IBEX" ]]; then
    module load  lammps/29Sep2021/openmpi-4.0.3_intel2020
    export LMP_CMD="/sw/csi/lammps/29Sep2021/openmpi-4.0.3_intel2020/install/bin/lmp_ibex"
    export OMP_NUM_THREADS=1
elif [[ $machine == "HPC" ]]; then
    # Test with care and HPC vasp is not compiled
    # with constrained relaxation functionality
    module purge
    module load kokkos/3.2.00/gcc-7.5.0-dd3pqj3
    module load cuda/11.5.0/gcc-7.5.0-syen6pj
    module unload zlib
    module load cmake/3.18.4/gcc-7.5.0-mbftn7v
    module load openmpi/4.1.1/gcc-7.5.0-fxaxwiu
    export LMP_CMD="${HOME}/Documents/applications/lammps/lammps-23Jun2022-kokkos/lammps-23Jun2022/build/lmp"
    # export OMP_PROC_BIND=spread 
    # export OMP_PLACES=threads
    export SLURM_NPROCS=12
    # export OMP_NUM_THREADS=1
fi


echo """
       JobId: ${SLURM_JOB_ID}
    NodeList: ${SLURM_JOB_NODELIST}
"""

# mpirun -np ${SLURM_NPROCS} ${LMP_CMD} -in in.reax -k on t 2 g 1 -sf kk
mpirun -np ${SLURM_NPROCS} ${LMP_CMD} -sf kk -k on g 1 -in in.reax

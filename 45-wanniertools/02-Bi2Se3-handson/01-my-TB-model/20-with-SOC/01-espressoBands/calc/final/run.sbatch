#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="BandBi2Se3"
#SBATCH --constraint=[intel|amd]
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --time=3:00:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive

machine="IBEX" # HPC or IBEX
if [[ $machine == "IBEX" ]]; then
    module load quantumespresso/6.6
elif [[ $machine == "HPC" ]]; then
    module load quantum-espresso/6.4.1/intel-19.1.0.166-mkl-openmpi-m2l27zt
    SLURM_NPROCS=24
fi


# SCF calculation for bulk
mpirun -np ${SLURM_NPROCS} pw.x -npool 2 -i INCAR-scf.pw > OUTCAR-scf.pw
# bands calculation for bulk
mpirun -np ${SLURM_NPROCS} pw.x -npool 2 -i INCAR-bands.pw > OUTCAR-bands.pw
# post processing for bulk bands
mpirun -np ${SLURM_NPROCS} bands.x -i INCAR-bands.bands > OUTCAR-bands.bands
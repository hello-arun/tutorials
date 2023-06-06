#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jobName"
#SBATCH --constraint=[intel|amd]
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=3:00:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std-%j.err
#SBATCH --output=./std.out
##SBATCH --exclusive

# On IBEX
    module load quantumespresso/6.6

# On Local HPC
    # module load quantum-espresso/6.4.1/intel-19.1.0.166-mkl-openmpi-m2l27zt  
    # SLURM_NPROCS=24

# Initial relaxation and scf 
mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-relax.pw > OUTCAR-relax.pw

# Check if convergence is achieved
grep "Begin final" OUTCAR-relax.pw
if [[ $? -eq 0 ]]; then
    echo "reached required accuracy"
    echo "No need to update INCAR-nscf.pw as coordinate are not read"
    echo "Now Doing NSCF run"
    # NSCF run for berry phase
    mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-nscf.pw > OUTCAR-nscf.pw
else
  echo "The strucure is not relaxed yet please rerun the calculation with latest cordinates"
  exit 1
fi
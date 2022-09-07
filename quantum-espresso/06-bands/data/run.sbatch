#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="InSe-Band"
#SBATCH --constraint=intel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=0:30:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive

# On IBEX
    module load quantumespresso/6.6

# On Local HPC
    # module load quantum-espresso/6.4.1/intel-19.1.0.166-mkl-openmpi-m2l27zt  
    # SLURM_NPROCS=24

# SCF run Initial 
mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-scf.pw > OUTCAR-scf.pw

# NSCF run for Bands
mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-bands.pw > OUTCAR-bands.pw

# Bands Postprocessing
mpirun -np ${SLURM_NPROCS} bands.x -i INCAR-bands.pp > OUTCAR-bands.pp


fermi=$(awk '/highest occupied/ || /Fermi/ {print $(NF-1)}' OUTCAR-scf.pw)
(echo "#fermi_energy $fermi eV" && awk '/high-symmetry point/ {print "#" $0}' OUTCAR-bands.pp && cat bands.gnu) > temp.txt && mv temp.txt bands.gnu 
python plot-bands.py --gnuFile bands.gnu --fermiFromFile --outFile bands.gnu --title "InSe Bands" --shiftVBM --range -4.0 4.0 --kPath "G,K,M,G"

# cp *png ../postProcessing/
# cp *svg ../postProcessing/
# module purge python/3.7.0
# module purge quantumespresso/6.6
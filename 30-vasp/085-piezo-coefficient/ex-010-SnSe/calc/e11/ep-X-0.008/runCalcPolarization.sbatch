#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="X0.008"
#SBATCH --constraint=amd
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=0:30:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive

srcDIR=$(pwd)
module load intel/2016
module load openmpi/4.0.3_intel
export VASP_CMD=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin/vasp_std
export OMP_NUM_THREADS=1

mpirun -np ${SLURM_NPROCS} ${VASP_CMD}

# # LBERRY METHOD
cd $srcDIR
calcDIR="${srcDIR}/pol-LBERRY"
mkdir -p $calcDIR
cp CHG* WAVECAR KPOINTS INCAR POTCAR grep-pol.sh "${calcDIR}/"
cp CONTCAR $calcDIR/POSCAR

# Change INCAR FILE
sed -i "/ISTART/c\ISTART=1" $calcDIR/INCAR
sed -i "/ICHARG/c\ICHARG=1" $calcDIR/INCAR
sed -i "/NSW/c\NSW = 0" $calcDIR/INCAR
sed -i "/IBRION/c\IBRION = -1" $calcDIR/INCAR

echo """\
# Polarization LBERRY Method
LBERRY = .TRUE.
IGPAR = 1 # 1: x-axis, 2:y-axis ...
NPPSTR = 15
# DIPOL = 0.10 0.10 0.50 # <Optinal>
""" >> $calcDIR/INCAR

cd $calcDIR
mpirun -np ${SLURM_NPROCS} ${VASP_CMD} > std.out

rm $srcDIR/grep-pol.sh

#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jobName"
#SBATCH --constraint=amd
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=128
#SBATCH --time=10:00:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
## SBATCH --exclusive

srcDIR=$(pwd)
module load intel/2016
module load openmpi/4.0.3_intel
export VASP_CMD=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin/vasp_std
export OMP_NUM_THREADS=1
export SLURM_NPROCS=256

echo """
       JobId: ${SLURM_JOB_ID}
    NodeList: ${SLURM_JOB_NODELIST}
    NumNodes: ${SLURM_NPROCS}
"""

mpirun -np ${SLURM_NPROCS} ${VASP_CMD}

# # LBERRY METHOD
cd $srcDIR
calcDIR="${srcDIR}/pol-LBERRY"
mkdir -p $calcDIR
cp CHG* WAVECAR KPOINTS INCAR POTCAR "${calcDIR}/"
cp CONTCAR $calcDIR/POSCAR

# Change INCAR FILE
sed -i "/ISTART/c\ISTART=1" $calcDIR/INCAR
sed -i "/ICHARG/c\ICHARG=1" $calcDIR/INCAR
sed -i "/NSW/c\NSW = 0" $calcDIR/INCAR
sed -i "/KPAR/c\KPAR = 1" $calcDIR/INCAR
sed -i "/IBRION/c\IBRION = -1" $calcDIR/INCAR

echo """\
# Polarization LBERRY Method
LBERRY = .TRUE.
IGPAR = 1 # 1: x-axis, 2:y-axis ...
NPPSTR = 3
""" >> $calcDIR/INCAR

cd $calcDIR
mpirun -np ${SLURM_NPROCS} ${VASP_CMD} >lberry.log 2>&1

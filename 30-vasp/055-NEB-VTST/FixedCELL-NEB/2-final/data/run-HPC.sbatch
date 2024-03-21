#!/bin/bash

# Test with care and HPC vasp is not compiled
# with constrained relaxation functionality
module load intel-mkl/2020.0.166/intel-19.1.0.166-wxnxb2u
module load openmpi/3.1.5/intel-19.1.0.166-6slj4uh
export VASP_HOME=/home/jangira/Documents/applications/vasp/bin
export OMP_NUM_THREADS=1
SLURM_NTASKS=24

echo """
                MACHINE: HPC
           SLURM_NODEID: ${SLURM_NODEID}
         SLURM_NODELIST: ${SLURM_NODELIST}
           SLURM_NNODES: ${SLURM_NNODES}
           SLURM_NTASKS: ${SLURM_NTASKS}
           SLURM_NPROCS: ${SLURM_NPROCS}
  SLURM_NTASKS_PER_CORE: ${SLURM_NTASKS_PER_CORE}
   SLURM_NTASKS_PER_GPU: ${SLURM_NTASKS_PER_GPU}
  SLURM_NTASKS_PER_NODE: ${SLURM_NTASKS_PER_NODE}
SLURM_NTASKS_PER_SOCKET: ${SLURM_NTASKS_PER_SOCKET}
"""

VASP_CMD="mpirun -np ${SLURM_NTASKS} ${VASP_HOME}/vasp_std"  # For Standard Calc
# VASP_CMD="mpirun -np ${SLURM_NTASKS} ${VASP_HOME}/vasp_ncl"  # For Spin Orbit Coupling

if [ -f "CONTCAR" ]; then
  echo "=========================================="
  echo "CONTCAR exist. Copying it."
  cp CONTCAR POSCAR
fi 

echo "=========================================="
echo "Doing a SCF run without dipole correction."
sed \
-e "s/__NSW/0/" \
-e "s/__ISTART/0/" \
-e "s/__ICHARG/2/" \
-e "s/__LDIPOL/False/" INCAR-base > INCAR
cp CHGCAR CHGCAR-noDIPOL
cp WAVECAR WAVECAR-noDIPOL
${VASP_CMD}

idx=1
while ! grep -q "reached required accuracy" OUTCAR; do
  echo "=========================================="
  echo "Accuracy not reached yet. Doing Relax Calculation."
  cp CONTCAR POSCAR
  cp XDATCAR XDATCAR-${idx}
  cp OUTCAR OUTCAR-${idx}
  ((idx++))
  sed \
  -e "s/__NSW/50/" \
  -e "s/__ISTART/1/" \
  -e "s/__ICHARG/1/" \
  -e "s/__LDIPOL/True/" INCAR-base > INCAR
  ${VASP_CMD}
done
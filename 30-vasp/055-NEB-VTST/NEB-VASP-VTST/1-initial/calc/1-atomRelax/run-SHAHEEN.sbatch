#!/bin/bash
#SBATCH --account=s1003
#SBATCH --partition=workq
#SBATCH --job-name="1-atomRelax"
#SBATCH --nodes=2
#SBATCH --time=2:00:00
#SBATCH --exclusive
#SBATCH --err=std.err
#SBATCH --output=std.out


#export VASP_USE=""  # This is the default
#export VASP_USE=_vaspsol # http://vaspsol.mse.ufl.edu/
#export VASP_USE=_scalapack
#export VASP_USE=_vtst # http://theory.cm.utexas.edu/vtsttools/
#export VASP_USE=_nbo # http://schmidt.chem.wisc.edu/nbosoftware

module load vasp/5.4.4
export OMP_NUM_THREADS=1
export SLURM_NPROCS=$((SLURM_NNODES*32))
echo """
                MACHINE: SHAHEEN
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

VASP_CMD="srun --ntasks=${SLURM_NPROCS} --hint=nomultithread ${VASP_HOME}/vasp_std"  # For Standard Calc
# VASP_CMD="srun --ntasks=${SLURM_NPROCS} --hint=nomultithread ${VASP_HOME}/vasp_ncl"  # For Spin Orbit Coupling


${VASP_CMD}


# if [ -e CONTCAR ]; then
#   echo "CONTCAR exists. Doing Relax Calculation with LDIPOL=True"
#   sed \
#   -e "s/__NSW/100/" \
#   -e "s/__LDIPOL/True/" INCAR-base > INCAR
#   ${VASP_CMD}
# else
#   echo "CONTCAR Does not exists. Doing single SCF LDIPOL=False"
#   sed \
#   -e "s/__NSW/0/" \
#   -e "s/__LDIPOL/False/" INCAR-base > INCAR
#   ${VASP_CMD}
#   cp CHGCAR CHGCAR-noDIPOL
#   cp WAVECAR WAVECAR-noDIPOL

#   echo -e "\n\n\n\n\n SCF Complete. Doing Relax with LDIPOL=True"
#   sed \
#   -e "s/__NSW/100/" \
#   -e "s/__LDIPOL/True/" INCAR-base > INCAR
#   ${VASP_CMD}
# fi

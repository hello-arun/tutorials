#!/bin/bash
#SBATCH --account=s1003
#SBATCH --partition=workq
#SBATCH --job-name="__jobName"
#SBATCH --nodes=10
#SBATCH --time=2:00:00
#SBATCH --exclusive
#SBATCH --err=std.err
#SBATCH --output=std.out

#----------------------------------------------------------#
#export VASP_USE=""  # This is the default, compiled with ScaLAPACK
#export VASP_USE=_omp # The version compiled with ScaLAPACK and threaded MKL
#export VASP_USE=_nbo # http://schmidt.chem.wisc.edu/nbosoftware
#export VASP_USE=_vaspsol # http://vaspsol.mse.ufl.edu/
export VASP_USE=_vtst178 # http://theory.cm.utexas.edu/vtsttools/
#export VASP_USE=_dftd4 # https://github.com/dftd4/dftd4_vasp
#export VASP_USE=_transopt # https://github.com/yangjio4849/TransOpt
#export VASP_USE=_z2pack # https://z2pack.greschd.ch/en/latest/tutorial/installation.html
#export VASP_USE=_libbeef # https://github.com/vossjo/libbeef
#export VASP_USE=_occmat # https://github.com/WatsonGroupTCD/Occupation-matrix-control-in-VASP

module load vasp/5.4.4
export OMP_NUM_THREADS=1
export SLURM_NTASKS=$((SLURM_NNODES*32))
echo """
                MACHINE: SHAHEEN
           SLURM_JOB_ID: ${SLURM_JOB_ID}
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

srun --ntasks=${SLURM_NTASKS} --hint=nomultithread ${VASP_HOME}/vasp_std

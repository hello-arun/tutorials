#!/bin/bash
#SBATCH --account=k10108
#SBATCH --partition=workq
#SBATCH --job-name=__jobName
#SBATCH --nodes=1
#SBATCH --time=2:00:00
#SBATCH --exclusive
#SBATCH --err=std.err
#SBATCH --output=std.out
#----------------------------------------------------------#
module switch PrgEnv-cray PrgEnv-intel
module switch intel intel/19.0.5.281
# module load vasp/5.4.4.pl2
#module load vasp/5.4.4.pl2_dftd4 # https://github.com/dftd4/dftd4_vasp
#module load vasp/5.4.4.pl2_libbeef # https://github.com/vossjo/libbeef
#module load vasp/5.4.4.pl2_nbo # http://schmidt.chem.wisc.edu/nbosoftware
#module load vasp/5.4.4.pl2_occmat # https://github.com/WatsonGroupTCD/Occupation-matrix-control-in-VASP
module load vasp/5.4.4.pl2_optaxis # https://github.com/Chengcheng-Xiao/VASP_OPT_AXIS (Fixing specific stress tensor element(s))
#module load vasp/5.4.4.pl2_transopt # https://github.com/yangjio4849/TransOpt
#module load vasp/5.4.4.pl2_vaspsol # http://vaspsol.mse.ufl.edu/
# module load vasp/5.4.4.pl2_vtst178 # http://theory.cm.utexas.edu/vtsttools/
#module load vasp/5.4.4.pl2_z2pack # https://z2pack.greschd.ch/en/latest/tutorial/installation.html
export FI_CXI_RX_MATCH_MODE=software
export MKL_DEBUG_CPU_TYPE=5
export MKL_CBWR=auto
export OMP_NUM_THREADS=1
echo """
                MACHINE: SHAHEEN
           SLURM_JOB_ID: ${SLURM_JOB_ID}
     SLURM_JOB_NODELIST:${SLURM_JOB_NODELIST}
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
nos=192
srun --ntasks=${nos} --map-by-numa --hint=nomultithread ${VASP_HOME}/vasp_std


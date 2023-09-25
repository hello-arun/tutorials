/bin/bash
#SBATCH --account=s1003
#SBATCH --partition=workq
#SBATCH --job-name="__jobName"
#SBATCH --nodes=2
#SBATCH --time=24:00:00
#SBATCH --exclusive
#SBATCH --err=std.err
#SBATCH --output=std.out
#----------------------------------------------------------#
#export VASP_USE=""  # This is the default
#export VASP_USE=_vaspsol # http://vaspsol.mse.ufl.edu/
#export VASP_USE=_scalapack
#export VASP_USE=_vtst # http://theory.cm.utexas.edu/vtsttools/
#export VASP_USE=_nbo # http://schmidt.chem.wisc.edu/nbosoftware
module load vasp/5.4.4
export OMP_NUM_THREADS=1
#----------------------------------------------------------#
echo "The job "${SLURM_JOB_ID}" is running on "${SLURM_JOB_NODELIST}
#----------------------------------------------------------#
srun --ntasks=64 --hint=nomultithread ${VASP_HOME}/vasp_std

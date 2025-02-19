#!/bin/bash
#SBATCH --account=k10108
#SBATCH --partition=workq
#SBATCH --job-name=Y-0.001
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

srcDIR=$(pwd)
nos=192
touch OUTCAR
idx=1
MAX_ITER=4
while ! grep -q "reached required accuracy" OUTCAR; do
  srun --ntasks=${nos} --map-by-numa --hint=nomultithread ${VASP_HOME}/vasp_std
  mv XDATCAR XDATCAR-$idx
  mv POSCAR POSCAR-$idx
  cp CONTCAR POSCAR

  idx=$((idx + 1))

  if [ "$idx" -gt "$MAX_ITER" ]; then
    echo "Error: Maximum number of iterations reached without convergence."
    exit 1
  fi
done

# # Calculate Polarization Along X-axis
# cd $srcDIR
# calcDIR="${srcDIR}/polX"
# mkdir -p $calcDIR
# cp CHG* WAVECAR KPOINTS INCAR POTCAR "${calcDIR}/"
# cp CONTCAR $calcDIR/POSCAR

# # Change INCAR FILE
# sed -i "/ISTART/c\ISTART=1" $calcDIR/INCAR
# sed -i "/ICHARG/c\ICHARG=1" $calcDIR/INCAR
# sed -i "/NSW/c\NSW = 0" $calcDIR/INCAR
# sed -i "/KPAR/c\KPAR = 1" $calcDIR/INCAR
# sed -i "/IBRION/c\IBRION = -1" $calcDIR/INCAR

# IGPAR=1 # 1: x-axis, 2:y-axis ...
# kpts=$(sed -n '4p' KPOINTS | awk "{print \$${IGPAR}}")
# cat <<EOF >> "$calcDIR/INCAR"
# # Polarization LBERRY Method
# LBERRY = .TRUE.
# IGPAR = $IGPAR # 1: x-axis, 2: y-axis ...
# NPPSTR = 8 #$kpts
# EOF

# cd $calcDIR
# srun --ntasks=${nos} --map-by-numa --hint=nomultithread ${VASP_HOME}/vasp_std > lberry.log 2> std.err
# echo "Polarization Calculation along x-axis completed"


# Calculate Polarization Along Y-axis
cd $srcDIR
calcDIR="${srcDIR}/polY"
mkdir -p $calcDIR
cp CHG* WAVECAR KPOINTS INCAR POTCAR "${calcDIR}/"
cp CONTCAR $calcDIR/POSCAR

# Change INCAR FILE
sed -i "/ISTART/c\ISTART=1" $calcDIR/INCAR
sed -i "/ICHARG/c\ICHARG=1" $calcDIR/INCAR
sed -i "/NSW/c\NSW = 0" $calcDIR/INCAR
sed -i "/KPAR/c\KPAR = 1" $calcDIR/INCAR
sed -i "/IBRION/c\IBRION = -1" $calcDIR/INCAR

IGPAR=2 # 1: x-axis, 2:y-axis ...
kpts=$(sed -n '4p' KPOINTS | awk "{print \$${IGPAR}}")
cat <<EOF >> "$calcDIR/INCAR"
# Polarization LBERRY Method
LBERRY = .TRUE.
IGPAR = $IGPAR # 1: x-axis, 2: y-axis ...
NPPSTR = 8 #$kpts
EOF

cd $calcDIR
srun --ntasks=${nos} --map-by-numa --hint=nomultithread ${VASP_HOME}/vasp_std > lberry.log 2> std.err
echo "Polarization Calculation along y-axis completed"


#!/bin/bash
#...........................
#SBATCH -N 1
#SBATCH --ntasks-per-node=128
#SBATCH --partition=debug
#SBATCH -J per1
#SBATCH -o std.out
#SBATCH -e std.err
#SBATCH --mail-type=ALL
#SBATCH --time=02:00:00
#SBATCH --mem=260G
#SBATCH --constraint="amd"
export OMP_NUM_THREADS=1
export MKL_DEBUG_CPU_TYPE=5
#...........................
nos=128
module purge; sleep 10s; module load intel/2022.3 openmpi/4.1.4/intel2022.3 vasp/5.4.4

export VASP_CMD="${VASP_HOME}/vasp_std"
export SLURM_NPROCS=128

echo """
       JobId: ${SLURM_JOB_ID}
    NodeList: ${SLURM_JOB_NODELIST}
    NumNodes: ${SLURM_NPROCS}
"""

srcDIR=$(pwd)
touch OUTCAR
idx=1
MAX_ITER=4
while ! grep -q "reached required accuracy" OUTCAR; do
  mpirun --bind-to core --map-by core -np ${nos} ${VASP_HOME}/vasp_std
  mv XDATCAR XDATCAR-$idx
  mv POSCAR POSCAR-$idx
  cp CONTCAR POSCAR

  idx=$((idx + 1))

  if [ "$idx" -gt "$MAX_ITER" ]; then
    echo "Error: Maximum number of iterations reached without convergence."
    exit 1
  fi
done

# Calculate Polarization Along X-axis
cd $srcDIR
calcDIR="${srcDIR}/polX"
mkdir -p $calcDIR
cp CHG* WAVECAR KPOINTS INCAR POTCAR "${calcDIR}/"
cp CONTCAR $calcDIR/POSCAR

# Change INCAR FILE
sed -i "/ISTART/c\ISTART=1" $calcDIR/INCAR
sed -i "/ICHARG/c\ICHARG=1" $calcDIR/INCAR
sed -i "/NSW/c\NSW = 0" $calcDIR/INCAR
sed -i "/KPAR/c\KPAR = 1" $calcDIR/INCAR
sed -i "/IBRION/c\IBRION = -1" $calcDIR/INCAR

IGPAR=1 # 1: x-axis, 2:y-axis ...
kpts=$(sed -n '4p' KPOINTS | awk "{print \$${IGPAR}}")
cat <<EOF >> "$calcDIR/INCAR"
# Polarization LBERRY Method
LBERRY = .TRUE.
IGPAR = $IGPAR # 1: x-axis, 2: y-axis ...
NPPSTR = 8 #$kpts
EOF

cd $calcDIR
mpirun --bind-to core --map-by core -np ${nos} ${VASP_HOME}/vasp_std > lberry.log 2> std.err
echo "Polarization Calculation along x-axis completed"


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
mpirun --bind-to core --map-by core -np ${nos} ${VASP_HOME}/vasp_std > lberry.log 2> std.err
echo "Polarization Calculation along y-axis completed"


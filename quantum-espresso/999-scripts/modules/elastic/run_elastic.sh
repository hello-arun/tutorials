#!/bin/bash
BIN_DIR="/ibex/scratch/jangira/qe/sw/qe-6.7/bin"

cat > ../thermo_control << EOF
 &INPUT_THERMO
  what='mur_lc_elastic_constants',
  frozen_ions=.FALSE.
 /
EOF


cat > ../run.sh <<EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH -J Elastic
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=3:00:00
#SBATCH --constraint=[cascadelake|skylake]

#run the application:
module load openmpi/3.0.0/gcc-6.4.0
mpirun -np \$(nproc) $BIN_DIR/thermo_pw.x < scf.in > scf.out

EOF

cd ../
sbatch run.sh

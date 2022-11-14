#!/bin/bash

vacuums="12 14 16 18 20 22 24 26 28 30 32 34"
SRC_DIR=$PWD
for vac in $vacuums; do
cd $SRC_DIR
mkdir -p ../vac_$vac
python /ibex/scratch/jangira/qe/npr/ZScripts/tools/vacOpt.py --inFile ../scf.in --outFile ../vac_$vac/scf.in --vac $vac
cat > ../vac_$vac/run.sh <<EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH -J VAC_$vac
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=0:30:00
module load quantumespresso/6.6
mpirun -np \$(nproc) pw.x <scf.in> scf.out
awk '/^!/ {print $vac, \$5}' scf.out >> ../etot_vs_vac.dat
EOF

cd ../vac_$vac
sbatch run.sh >> ../ZScripts/jobs.sh

done
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=32
#SBATCH --partition=batch
#SBATCH -J Job1
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=1:30:00
#SBATCH --constraint=[cascadelake|skylake]


#run the application:
module load quantumespresso/6.6

k=8
Wfcs='35 45 55 80 90 130'
rho=400
dgs=0.02
PREFIX=`awk '/PREFIX/ {print $3}' base.sh`
SCRIPT_DIR=$PWD
# remove these comments in case you need to override something
# SRC_DIR=../GeS/GeS_600rho_90wfc_8k/qe
# PREFIX=GeS

cd ../
SRC_DIR=$PWD
# rm -f $PREFIX.etot_vs_wfc
for wfc in $Wfcs
do
awk -v dgs="$dgs" -v wfc="$wfc" -v rho="$rho" -v k="$k" -v vk="-1" '/ecutwfc/ { $3 = wfc } 
/K_POINTS/ {vk = NR} NR == vk+1 {$0 = k" "k" "1" 0 0 0"} 
/degauss/ {$3= dgs}
/ecutrho/ {$3 = rho} {print $0} ' $PREFIX.scf.in > $PREFIX.scf.${wfc}wfc.in
mpirun -np 32 pw.x <$PREFIX.scf.${wfc}wfc.in> $PREFIX.scf.${wfc}wfc.out
awk -v x=$wfc '/^!/ {print x, $5}' $PREFIX.scf.${wfc}wfc.out >> $PREFIX.etot_vs_wfc
done
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH -J Job1
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=1:30:00
#SBATCH --constraint=[cascadelake|skylake]



#run the application:
module load quantumespresso/6.6

Ks='04 08 12 24 32'
wfc=90
rho=600
dgs=0.02
PREFIX=`awk '/PREFIX/ {print $3}' base.sh`
SCRIPT_DIR=$PWD
# remove these comments in case you need to override something
# SRC_DIR=../GeS/GeS_600rho_90wfc_8k/qe
# PREFIX=GeS

cd ../
SRC_DIR=$PWD
rm -f $PREFIX.etot_vs_k
for k in $Ks
do
awk -v dgs="$dgs" -v wfc="$wfc" -v rho="$rho" -v k="$k" -v vk="-1" '/ecutwfc/ { $3 = wfc } 
/K_POINTS/ {vk = NR} NR == vk+1 {$0 = k" "k" "1" 0 0 0"} 
/degauss/ {$3= dgs}
/ecutrho/ {$3 = rho} {print $0} ' $PREFIX.scf.in > $PREFIX.scf.${k}k.in
mpirun -np 24 pw.x <$PREFIX.scf.${k}k.in> $PREFIX.scf.${k}k.out
awk -v x=$k '/^!/ {print x, $5}' $PREFIX.scf.${k}k.out >> $PREFIX.etot_vs_k
done

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
SCRIPT_DIR=$PWD

PREFIX=`awk '/PREFIX/ {print $3}' base.sh`
cd ../
SRC_DIR=$PWD
module load quantumespresso/6.6
module load python/3.7.0

for efield in $(awk ' BEGIN { for( i = 5; i < 21 ; i++) {x=x" "sprintf("%0.3f",i*0.001)} print(x) }')
do
awk -v efield="$efield" '/efield_cart\(3\)/ { $3 = efield } {print $0} ' $PREFIX.scf.in > $PREFIX.scf.ef_$efield.in
awk -v efield="$efield" '/efield_cart\(3\)/ { $3 = efield } {print $0} ' $PREFIX.bands.in > $PREFIX.bands.ef_$efield.in
cat  > bands.in << EOF
&BANDS
    outdir  = './out'
    filband = '$PREFIX.bands.ef_$efield'
/
EOF

mpirun -np 32 pw.x <$PREFIX.scf.ef_$efield.in> $PREFIX.scf.ef_$efield.out
mpirun -np 32 pw.x <$PREFIX.bands.ef_$efield.in> $PREFIX.bands.ef_$efield.out

ef=$(grep "highest occupied\|Fermi" $PREFIX.scf.ef_$efield.out)
mpirun -np 12 bands.x <bands.in > bands.ef_$efield.out

(echo "# $ef" && cat $PREFIX.bands.ef_$efield.gnu) > temp.txt && mv temp.txt $PREFIX.bands.ef_$efield.gnu

python $SCRIPT_DIR/Bands.py $PREFIX.bands.ef_$eamp.gnu $ef bands.ef_$eamp.out $PREFIX.ef_$eamp


done

moudle purge python/3.7.0
moudel purge quantumespresso/6.6
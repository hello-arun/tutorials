#!/bin/bash
nproc=24

SCRIPT_DIR=$PWD
PREFIX=`awk '/PREFIX/ {print $3}' base.sh`

cd ../
SRC_DIR=$PWD


for eamp in $(awk ' BEGIN { for( i = 0; i <= 10 ; i+=2) {x=x" "sprintf("%0.4f",i*0.001)} print(x) }')
do
cd $SRC_DIR
echo $PWD
mkdir -p ef_$eamp
awk -v eamp="$eamp" '/eamp/ { $3 = eamp } {print $0} ' $PREFIX.scf.in > ef_$eamp/$PREFIX.scf.ef_$eamp.in
awk -v eamp="$eamp" '/eamp/ { $3 = eamp } {print $0} ' $PREFIX.bands.in > ef_$eamp/$PREFIX.bands.ef_$eamp.in
cat  > ef_$eamp/bands.in << EOF
&BANDS
    outdir  = './out'
    filband = '$PREFIX.bands.ef_$eamp'
/
EOF

cat > ./ef_$eamp/run.sh <<EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=$nproc
#SBATCH --partition=batch
#SBATCH -J Job1
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=0:30:00
#run the application:
module load quantumespresso/6.6
module load python/3.7.0
mpirun -np $nproc pw.x <$PREFIX.scf.ef_$eamp.in> $PREFIX.scf.ef_$eamp.out
mpirun -np $nproc  pw.x <$PREFIX.bands.ef_$eamp.in> $PREFIX.bands.ef_$eamp.out
mpirun -np 1 bands.x <bands.in > bands.ef_$eamp.out
cp bands.ef_$eamp.out ../
cp $PREFIX.bands.ef_$eamp.out ../
cp $PREFIX.scf.ef_$eamp.out ../

ef=\$(awk '/highest occupied/ || /Fermi/ {print \$(NF-1)}' $PREFIX.scf.ef_$eamp.out)
(echo "# \$ef" && cat $PREFIX.bands.ef_$eamp.gnu) > temp.txt && mv temp.txt $PREFIX.bands.ef_$eamp.gnu
python $SCRIPT_DIR/Bands.py $PREFIX.bands.ef_$eamp.gnu \$ef bands.ef_$eamp.out $PREFIX.ef_$eamp

cp *png ../
cp *svg ../
moudle purge python/3.7.0
moudel purge quantumespresso/6.6
EOF

cd ./ef_$eamp
echo $PWD
sbatch run.sh
done


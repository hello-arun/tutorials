#!/bin/bash

quantity="eamp"           #the variable in the scf file to change valeus you can name it random  to calculate without any change
values="0.0000 0.0020 0.0040 0.0060 0.0080 0.0100 0.0120 0.0140 0.0160"      # when you want to calculate without any change just put any single value here
# values=$(awk ' BEGIN { for( i = 0; i <= 4 ; i+=2) {x=x" "sprintf("%0.4f",i*0.001)} print(x) }')

nproc=24
constraint="#SBATCH --constraint=[cascadelake|skylake]"
# constraint=""
K_PATH=`awk '/^k_path/ {print $3}' base.sh`


SCRIPT_DIR=$PWD
ppDir=`readlink -f ../postProcessing`
cd ../
mkdir -p $ppDir/$quantity
for value in $values
do
echo $value >> $ppDir/$quantity/list.sh
mkdir -p $quantity/$value
awk -v value="$value" -v quantity="$quantity" '$0 ~ quantity {$3 = value} {print}' ./scf.in > ./$quantity/$value/scf.in
awk -v value="$value" -v quantity="$quantity" '$0 ~ quantity {$3 = value} {print}' ./bands.in > ./$quantity/$value/bands.in

cat > ./$quantity/$value/pp.bands.in <<EOF
&BANDS
    outdir  = './out'
    filband = 'bands'
/
EOF

cat > ./$quantity/$value/runBands.sh << EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=$nproc
#SBATCH --partition=batch
#SBATCH -J Bands
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=0:30:00
${constraint}
#run the application:
module load quantumespresso/6.6
module load python/3.7.0
mpirun -np $nproc pw.x <scf.in> scf.out
mpirun -np $nproc  pw.x <bands.in> bands.out
mpirun -np $nproc bands.x <pp.bands.in > pp.bands.out

ef=\$(awk '/highest occupied/ || /Fermi/ {print \$(NF-1)}' scf.out)
(echo "#fermi_energy \$ef ev " && awk '/high-symmetry point/ {print "#" \$0}' pp.bands.out && cat bands.gnu) > temp.txt && mv temp.txt bands.gnu 
python $SCRIPT_DIR/Bands.py --gnuFile bands.gnu --fermiFromFile --outFile bands.gnu --title $value --shiftVBM --range -4.0 4.0 --kPath $K_PATH 

cp *png $ppDir/$quantity/
cp *svg $ppDir/$quantity/
module purge python/3.7.0
module purge quantumespresso/6.6
EOF

cat > ./$quantity/$value/plotBands.sh << EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=debug
#SBATCH -J PlotBands
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=0:30:00
#run the application:
module load python/3.7.0

ef=\$(awk '/highest occupied/ || /Fermi/ {print \$(NF-1)}' scf.out)

(echo "#fermi_energy \$ef ev " && awk '/high-symmetry point/ {print "#" \$0}' pp.bands.out && cat bands.gnu) > temp.txt && mv temp.txt bands.gnu 
python $SCRIPT_DIR/Bands.py --gnuFile bands.gnu --fermiFromFile --outFile bands.gnu --title $value --shiftVBM --range -4.0 4.0 --kPath $K_PATH 

cp *png $ppDir/$quantity/
cp *svg $ppDir/$quantity/

module purge python/3.7.0
EOF

cd ./$quantity/$value
echo "$quantity/$value" >> $SCRIPT_DIR/jobs.sh 
sbatch runBands.sh >> $SCRIPT_DIR/jobs.sh
echo " " >> $SCRIPT_DIR/jobs.sh 
cd $SCRIPT_DIR/../
done
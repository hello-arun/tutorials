#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=debug
#SBATCH -J Job1
#SBATCH -o Job1.%J.outk
#SBATCH -e Job1.%J.err
#SBATCH --time=0:30:00

#run the application:

PREFIX=`awk '/PREFIX/ {print $3}' base.sh`
SCRIPT_DIR=$PWD
cd ../
SRC_DIR=$PWD

module load python/3.7.0

python $SCRIPT_DIR/automateEverything.py $PREFIX

pseudo_dir=$(awk '/pseudo_dir/ {printf"%s",$3" "}' $PREFIX.relax.in)
len=${#pseudo_dir}
len=$(echo "$len - 3 " | bc)
pseudo_dir=$(echo $pseudo_dir | cut -c2-$len )
echo $pseudo_dir
potentials=$(awk '/UPF/ {printf"%s",$3" "}' $PREFIX.relax.in)




# ########################### for X Axis #####################
for strain in $(cat $SRC_DIR/$PREFIX.strainXInputs.txt)
do
#Make a directory
mkdir -p $SRC_DIR/$PREFIX.relax.X$strain
#copying pseudo pot
cd $pseudo_dir
for pot in $potentials
do
cp $pot  $SRC_DIR/$PREFIX.relax.X$strain/
done

#Copying input
cd $SRC_DIR
cp $PREFIX.relax.X$strain.in $PREFIX.relax.X$strain/$PREFIX.relax.X$strain.in 
cd $SRC_DIR/$PREFIX.relax.X$strain

(cat $SCRIPT_DIR/helper.sh && 
echo "mpirun -np 32 pw.x <$PREFIX.relax.X$strain.in> $PREFIX.relax.X$strain.out" && 
echo "cp $PREFIX.relax.X$strain.out ../" &&
echo "cd .." &&
echo "rm -r $PREFIX.relax.X$strain") > $PREFIX.relax.X$strain.sh
sbatch $PREFIX.relax.X$strain.sh
done

########################### for Y Axis #####################
for strain in $(cat $SRC_DIR/$PREFIX.strainYInputs.txt)
do
mkdir -p $SRC_DIR/$PREFIX.relax.Y$strain
cd $pseudo_dir
for pot in $potentials
do
cp $pot  $SRC_DIR/$PREFIX.relax.Y$strain/
done
cd $SRC_DIR
cp $PREFIX.relax.Y$strain.in $PREFIX.relax.Y$strain/$PREFIX.relax.Y$strain.in 
cd $SRC_DIR/$PREFIX.relax.Y$strain
(cat $SCRIPT_DIR/helper.sh && 
echo "mpirun -np 32 pw.x <$PREFIX.relax.Y$strain.in> $PREFIX.relax.Y$strain.out" && 
echo "cp $PREFIX.relax.Y$strain.out ../" &&
echo "cd .." &&
echo "rm -r $PREFIX.relax.Y$strain") > $PREFIX.relax.Y$strain.sh
sbatch $PREFIX.relax.Y$strain.sh
done
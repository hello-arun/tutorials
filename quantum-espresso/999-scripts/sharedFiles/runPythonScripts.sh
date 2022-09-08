#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=debug
#SBATCH -J Job1
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=0:30:00

#run the application:

SCRIPT_DIR=$PWD
# Folder where different output or input files are stored in
# SRC_DIR=`awk '/folder/ {print $3}' base.sh`
PREFIX=`awk '/PREFIX/ {print $3}' base.sh`

# remove these comments in case you need to override something
# SRC_DIR=../GeS/GeS_600rho_90wfc_8k/qe
# PREFIX=GeS

cd ../
SRC_DIR=$PWD

module load python/3.7.0

# python $SCRIPT_DIR/automateEverything.py $PREFIX
python $SCRIPT_DIR/extractData.py $PREFIX XY
# python $SCRIPT_DIR/relaxToLammpsCrystal.py $PREFIX XY
# python $SCRIPT_DIR/relaxToLammpsAlat.py $PREFIX XY
# python $SCRIPT_DIR/automateEverything2.py $PREFIX
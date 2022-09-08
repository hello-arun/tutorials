#!/bin/bash

PREFIX=`awk '/PREFIX/ {print $3}' base.sh`
SCRIPT_DIR=$PWD
cd ../
SRC_DIR=$PWD
echo 
echo .................
echo Reading_Inputs
echo Target_$SRC_DIR
echo Prefix_$PREFIX
echo PWD_$SCRIPT_DIR

echo Copying_files_to_target

mkdir -p scripts
cd ./scripts
cp $SCRIPT_DIR/base.sh ./
cp $SCRIPT_DIR/baseFiles/runQEScript.sh ./
cp $SCRIPT_DIR/baseFiles/runBatchQEScripts.sh ./
cp $SCRIPT_DIR/baseFiles/automateEverything.py ./
cp $SCRIPT_DIR/baseFiles/extractData.py ./
cp $SCRIPT_DIR/baseFiles/helper.sh ./
cp $SCRIPT_DIR/baseFiles/runPythonScripts.sh ./

echo Copying_Done.......
echo ...................
echo Running_scripts....
echo PWD_$PWD
echo
sbatch runQEScript.sh
echo
echo ...................



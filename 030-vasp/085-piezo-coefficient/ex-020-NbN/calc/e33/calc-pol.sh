#!/bin/bash
displacements="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15"
srcDIR=$(pwd)
for disp in $displacements; do
cd $srcDIR/disp-$disp
echo "disp-$disp Doing"
python chgcen.py ./CHGCAR ./OUTCAR > chgcen.log
echo "disp-$disp Done"
cd $srcDIR
done
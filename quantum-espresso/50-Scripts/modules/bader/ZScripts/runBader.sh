#!/bin/bash
qty="eamp"
cd ../postProcessing
list=$(cat ./${qty}/list.sh)
cd ./$qty
echo "" > log.log
for i in $list; do
    bader val_chden_${i//${qty}_/}.cube -ref all_chden_${i//${qty}_/}.cube >>log.log
    mv ACF.dat ACF_${i//${qty}_/}.dat
    mv BCF.dat BCF_${i//${qty}_/}.dat
    mv AVF.dat AVF_${i//${qty}_/}.dat
done

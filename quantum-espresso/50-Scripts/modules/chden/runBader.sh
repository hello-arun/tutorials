#!/bin/bash
qty="eamp"
cd ../postProcessing
list=$(cat ./${qty}/list.sh)
cd ./$qty
for i in $list; do
    bader chden_${i}.cube >>log.log
    mv ACF.dat ACF_${i}.dat
    mv BCF.dat BCF_${i}.dat
    mv AVF.dat AVF_${i}.dat
done

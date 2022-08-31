#!/bin/bash
qty="eamp"
mkdir -p ../postProcessing/
cd $_
for i in `cat ./$qty/list.sh`
do
cp ../$qty/$i/*cube ./$qty/chden_${i}.cube
done
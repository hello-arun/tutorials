#!/bin/bash
mkdir -p ../postProcessing/eamp
cd $_
for i in `cat ../eamp_list.sh`
do
cp ../../$i/*0.cube ./val_chden_${i//eamp_/}.cube
cp ../../$i/*21.cube ./all_chden_${i//eamp_/}.cube

done
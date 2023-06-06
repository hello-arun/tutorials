#!/bin/bash

PREFIX=`awk '/^PREFIX/ {print $3}' base.sh`
scriptDIR=$PWD
ppDIR="$scriptDIR/../postProcessing"
cd $ppDIR
if [ $# -eq 0 ]; then
quantitys=`ls`
else
quantitys=`ls ${1}`
fi
echo Lists are 
echo $quantitys
for quantity in $quantitys
do
outDIR="$ppDIR/$quantity"
srcDIR="$scriptDIR/../$quantity"

echo "Trying to collect for $quantity"
values=`cat $quantity/list.sh`
for value in $values
do
mkdir -p $outDIR/$value/
echo .......trying to execute script
cd $srcDIR/$value
python ./ZScripts/extractData.py $PREFIX XY
python $scriptDIR/baseFiles/extractAngleData.py --i ./ --o ./postProcessing --axis X

echo now copying from $value
cp -r $srcDIR/$value/postProcessing/* $outDIR/$value/
echo copy "done" for  $value
done

done

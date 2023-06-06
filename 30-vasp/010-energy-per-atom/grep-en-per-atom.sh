#!/bin/bash

systems="C02K0  C32K1  C32K2  C32K2-veryclose  C32K3  C32K4"
outFile="en-per-atom.csv"
rm -f $outFile

echo "System,NIONS,TOTEN,EN_PER_ATOM" >>$outFile
for system in $systems; do
    OUTCAR="$system/calc/OUTCAR"
    grep "reached required accuracy" $OUTCAR
    if [[ $? -eq 0 ]]; then
        TOTEN=$(grep "TOTEN" $OUTCAR | tail -1 | awk '{print $5}')
        NIONS=$(awk '/NIONS/ {print $12}' $OUTCAR)
        EN_PER_ATOM=$(echo "scale=8; $TOTEN/$NIONS" | bc -lq)
        echo "${system},${NIONS},${TOTEN},${EN_PER_ATOM}" >>$outFile
    fi
done

column -t TOTENS.dat >temp.dat
mv temp.dat TOTENS.dat

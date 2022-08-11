#!/bin/bash

System="Single-K-atom"
vacuums=`seq 10 2 20`
outFile="en-per-atom.csv"
rm -f $outFile

echo "VACUUM,NIONS,TOTEN,EN_PER_ATOM" >>$outFile
for vacuum in $vacuums; do
    OUTCAR="./calc/vac-${vacuum}/OUTCAR"
    # grep "reached required accuracy" $OUTCAR
    if [[ $? -eq 0 ]]; then
        TOTEN=$(grep "TOTEN" $OUTCAR | tail -1 | awk '{print $5}')
        NIONS=$(awk '/NIONS/ {print $12}' $OUTCAR)
        EN_PER_ATOM=$(echo "scale=8; $TOTEN/$NIONS" | bc -lq)
        echo "${vacuum},${NIONS},${TOTEN},${EN_PER_ATOM}" >>$outFile
    fi
done

# column -t $outFile >temp
# mv temp $outFile

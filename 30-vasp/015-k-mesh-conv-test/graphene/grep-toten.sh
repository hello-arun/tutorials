#!/bin/bash

kMeshes=" 4x4x1  8x8x1 16x16x1  24x24x1  8x8x2 16x16x2 "
outFile="toten.csv"
rm -f $outFile

echo "kMesh,cpuTime,elapsedTime,toten" >>$outFile
for kMesh in $kMeshes; do
    OUTCAR="./calc/KPOINTS/$kMesh/OUTCAR"
    toten=$(grep "TOTEN" $OUTCAR | tail -1 | awk '{print $5}')
    cpuTime=$(grep "Total CPU time" $OUTCAR | awk '{print $(NF)}')
    elapsedTime=$(grep "Elapsed time" $OUTCAR | awk '{print $(NF)}')
    echo "${kMesh},${cpuTime},${elapsedTime},${toten}" >>$outFile
done


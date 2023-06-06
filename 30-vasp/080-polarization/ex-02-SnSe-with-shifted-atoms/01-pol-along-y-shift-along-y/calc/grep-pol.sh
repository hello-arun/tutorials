#!/bin/bash
disps="0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90"
polAxis="2" # polarization along x,or y axis.. 1:x, 2:y

polAxisMarker=$((5+$polAxis))
outFile="polarization.csv"

echo "disp, pIon, pEle, vol, a, b, c, shift" > ${outFile}
echo "#_unitless, e*Angst, e*Angst,  Ang^3, Ang, Ang, Ang, Integer" >> ${outFile}

for disp in $disps; do
    OUTCAR="./disp-${disp}/pol-LBERRY/OUTCAR"
    pEle=$(grep "p\[elc\]" $OUTCAR | awk "{print \$$polAxisMarker}")
    pIon=$(grep "p\[ion\]" $OUTCAR | awk "{print \$$(($polAxisMarker-1))}")
    vol=$(grep "volume of cell" $OUTCAR | tail -1 | awk '{print $5}')
    cellVectors=$(grep "length of vectors" $OUTCAR -A1 | tail -1 | awk '{print $1", "$2", "$3}')
    echo "$disp, $pIon, $pEle, $vol", $cellVectors, 0 >> ${outFile}
done

column -t ${outFile} > temp
mv temp $outFile

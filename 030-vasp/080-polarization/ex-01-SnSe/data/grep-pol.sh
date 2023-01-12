#!/bin/bash
strains=$(seq -0.010 0.002 0.010)
polAxis="1" # polarization along x,or y axis.. 1:x, 2:y
strainAxisLabel="X" # Polarization along X or Y Axis

polAxisMarker=$((5+$polAxis))
outFile="polarization.csv"

echo "ep_$strainAxisLabel, pIon, pEle, vol, a, b, c, shift" > ${outFile}
echo "#_unitless, e*Angst, e*Angst,  Ang^3, Ang, Ang, Ang, Integer" >> ${outFile}

for strain in $strains; do
    OUTCAR="./ep-${strainAxisLabel}-${strain}/pol-LBERRY/OUTCAR"
    pEle=$(grep "p\[elc\]" $OUTCAR | awk "{print \$$polAxisMarker}")
    pIon=$(grep "p\[ion\]" $OUTCAR | awk "{print \$$(($polAxisMarker-1))}")
    vol=$(grep "volume of cell" $OUTCAR | tail -1 | awk '{print $5}')
    cellVectors=$(grep "length of vectors" $OUTCAR -A1 | tail -1 | awk '{print $1", "$2", "$3}')
    echo "$strain, $pIon, $pEle, $vol", $cellVectors, 0 >> ${outFile}
done

column -t ${outFile} > temp
mv temp $outFile

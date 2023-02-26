#!/bin/bash
displacements="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15"
polAxis="1" # polarization along x,or y axis.. 1:x, 2:y
dispAxisLabel="Z" # Polarization along X or Y Axis

polAxisMarker=9
outFile="polarization.csv"

echo "disp_$dispAxisLabel, pIon, pEle, pTot, vol, a, b, c, shift" > ${outFile}
echo "#_unitless, e*Angst, e*Angst, e*Angst,  Ang^3, Ang, Ang, Ang, Integer" >> ${outFile}

for disp in $displacements; do
    OUTCAR="./disp-${disp}/OUTCAR"
    chgcen="./disp-${disp}/chgcen.log"
    pEle=$(grep "Total elect dipole" $chgcen | awk "{print \$$polAxisMarker}")
    pIon=$(grep "Total ionic dipole" $chgcen | awk "{print \$$polAxisMarker}")
    pTot=$(grep "Total dipole moments" $chgcen | awk "{print \$$(($polAxisMarker-1))}")
    vol=$(grep "volume of cell" $OUTCAR | tail -1 | awk '{print $5}')
    cellVectors=$(grep "length of vectors" $OUTCAR -A1 | tail -1 | awk '{print $1", "$2", "$3}')
    echo "$disp, $pIon, $pEle, $pTot, $vol", $cellVectors, 0 >> ${outFile}
done

column -t ${outFile} > temp
mv temp $outFile

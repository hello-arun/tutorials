#!/bin/bash
strains=$(seq -0.008 0.004 0.008)
# polAxis="1" # polarization along x,or y axis.. 1:x, 2:y



for polAxis in 1 2; do
    case "$polAxis" in
        1) outFile="polX.csv" ;;
        2) outFile="polY.csv" ;;
        3) outFile="polZ.csv" ;;
        *) echo "Error: Invalid polAxis value. Must be 1, 2, or 3." >&2; exit 1 ;;
    esac
    echo "polAxis, epsilon, pIon, pEle, vol, a, b, c, shift" > ${outFile}
    echo "#Int, Float, e*Angst, e*Angst, Ang^3, Ang, Ang, Ang, Integer" >> ${outFile}
    polAxisMarker=$((5+$polAxis))
    for strain in $strains; do
        OUTCAR="./${strain}/polX/OUTCAR"
        pEle=$(grep "p\[elc\]" $OUTCAR | awk "{print \$$polAxisMarker}")
        pIon=$(grep "p\[ion\]" $OUTCAR | awk "{print \$$(($polAxisMarker-1))}")
        vol=$(grep "volume of cell" $OUTCAR | tail -1 | awk '{print $5}')
        cellVectors=$(grep "length of vectors" $OUTCAR -A1 | tail -1 | awk '{print $1", "$2", "$3}')
        echo "$polAxis, $strain, $pIon, $pEle, $vol", $cellVectors, 0 >> ${outFile}
    done
    column -t ${outFile} > temp
    mv temp $outFile
done
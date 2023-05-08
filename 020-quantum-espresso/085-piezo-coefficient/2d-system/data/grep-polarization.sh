#!/bin/bash
strains=$(seq -0.010 0.002 0.010)
polAxis="3" # polarization along x,or y axis.. 1:x, 2:y, 3:z
strainAxisLabel="Z" # Polarization along X or Y or Z Axis

polAxisMarker=$((5+$polAxis))
outFile="polarization.csv"
tempFile=$(mktemp)
Ang=0.529177 # bohr to angstrom factor
Ang3=$(echo ${Ang}^3 | bc -l) # bohr^3 to Ang^3

echo "ep_${strainAxisLabel}, pol3d, quanta3d, vol, a, b, c, shift" > ${outFile}
echo "#_unitless, coulomb/meter^2,  coulomb/meter^2, Ang^3, Ang, Ang, Ang, Integer" >> ${outFile}
for strain in $strains; do
    OUTCAR="./ep-${strainAxisLabel}-${strain}/OUTCAR-nscf.pw"
    vol=$(grep "unit-cell volume" $OUTCAR | awk "{print \$4*$Ang3}")
    alat=$(grep "lattice parameter" $OUTCAR | awk "{print \$5*$Ang}")
    a=$(grep "a(1)" $OUTCAR | awk "{print \$4*$alat}")
    b=$(grep "a(2)" $OUTCAR | awk "{print \$5*$alat}")
    c=$(grep "a(3)" $OUTCAR | awk "{print \$6*$alat}")
    pol3d=$(grep "P = " $OUTCAR | tail -1 | awk '{print $3}')
    quanta3d=$(grep "P = " $OUTCAR | tail -1 | awk '{print $5}' | tr -d ")")
    echo "${strain}, ${pol3d}, ${quanta3d}, ${vol}, ${a}, ${b}, ${c}, 0" >> $outFile
done

column -t $outFile > ${tempFile}
mv ${tempFile} $outFile
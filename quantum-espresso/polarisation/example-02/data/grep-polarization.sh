#!/bin/bash

strains=$(seq -0.010 0.005 0.010)
outFile="polarization.csv"
touch ${outFile}
echo "strain, polarization" > ${outFile}
echo "#_unitless, coulomb/meter^2" >> ${outFile}
for strain in $strains; do 
    pol=$(grep "P = " ./ep_x${strain}/OUTCAR-nscf.pw | tail -1 | awk '{print $3}')
    echo "${strain}, ${pol}" >> $outFile
done

column -t $outFile > ./temp
mv temp $outFile
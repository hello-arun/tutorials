
quantity="ecutwfc"
values="50 60 70 80 90"

outFile="en-vs-value.csv"
rm -f $outFile

echo """${quantity}, nions, nkpts, toten, enPerAtom, cpuTime, elapsedTime
#-, number, number, Ry, Ry/atom, time, time""" >$outFile

for value in $values; do
    OUTCAR="./$value/OUTCAR-scf.pw"
    nions=$(awk '/number of atoms/ {print $5}' $OUTCAR)
    toten=$(grep "!    total energy" $OUTCAR | tail -1 | awk '{print $5}')
    enPerAtom=$(echo "scale=8; $toten/$nions" | bc -lq)
    cpuTime=$(grep "PWSCF        :" $OUTCAR | awk '{print $3}')
    elapsedTime=$(grep "PWSCF        :" $OUTCAR | awk '{print $5}')
    nkpts=$(grep "number of k points=" $OUTCAR | awk '{print $5}')
    echo "${value}, ${nions}, $nkpts, $toten, $enPerAtom, ${cpuTime}, ${elapsedTime}" >> $outFile
done

column -t $outFile >temp.dat
mv temp.dat $outFile
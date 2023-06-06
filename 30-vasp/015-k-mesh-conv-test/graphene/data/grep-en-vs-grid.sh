# ls grid* -d
grids="grid-1x1x1  grid-2x2x1  grid-3x3x1  grid-4x4x1 grid-5x5x1"

outFile="en-vs-grid.csv"
rm -f $outFile

echo """grid, nkpts, enPerAtom, cpuTime, elapsedTime
#-, number, eV/atom, sec, sec""" >$outFile

for grid in $grids; do
    OUTCAR="./$grid/OUTCAR"
    nions=$(awk '/NIONS/ {print $12}' $OUTCAR)
    toten=$(grep "TOTEN" $OUTCAR | tail -1 | awk '{print $5}')
    enPerAtom=$(echo "scale=8; $toten/$nions" | bc -lq)
    cpuTime=$(grep "Total CPU time" $OUTCAR | awk '{print $(NF)}')
    elapsedTime=$(grep "Elapsed time" $OUTCAR | awk '{print $(NF)}')
    nkpts=$(grep "NKPTS" $OUTCAR | awk '{print $4}')
    echo "${grid/grid-/}, $nkpts, $enPerAtom, ${cpuTime}, ${elapsedTime}" >> $outFile
done

column -t $outFile >temp.dat
mv temp.dat $outFile
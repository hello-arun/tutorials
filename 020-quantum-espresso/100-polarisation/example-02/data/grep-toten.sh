strains=$(seq -0.006 0.002 0.006)
echo "ep_x, ep_y, area(ang^2), toten(Ry)" >toten.csv
for ep_x in $strains; do
    for ep_y in $strains; do
        OUTCAR=./ep_${ep_x}_${ep_y}/OUTCAR.pw
        toten=$(grep "Final energy" $OUTCAR | tail -1 | awk '{print $4}')
        volume=$(grep "unit-cell volume" $OUTCAR | tail -1 | awk '{print $4}')
        volume_ang3=$(echo $volume*0.529177249*0.529177249*0.529177249 | bc -l)
        area=$(echo "${volume_ang3}/20.0" | bc -l)
        echo "$ep_x, $ep_y, $area, $toten" >>toten.csv
    done
done

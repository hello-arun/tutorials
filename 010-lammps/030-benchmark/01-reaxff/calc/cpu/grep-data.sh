outFile="time-vs-setting.txt"
tmpFile="$(mktemp)"
echo -e "core, time \n#Number, sec" > $tmpFile

time=$(grep "Loop" 01-N1C1/log.lammps | awk '{print $4}')
echo "1, ${time}" >>$tmpFile

time=$(grep "Loop" 02-N1C4/log.lammps | awk '{print $4}')
echo "4, ${time}" >>$tmpFile

time=$(grep "Loop" 03-N1C12/log.lammps | awk '{print $4}')
echo "12, ${time}" >>$tmpFile

time=$(grep "Loop" 04-N1C24/log.lammps | awk '{print $4}')
echo "24, ${time}" >>$tmpFile

column -t $tmpFile > $outFile
rm $tmpFile
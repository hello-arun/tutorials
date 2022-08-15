#!/bin/bash
natoms=$(grep "atoms" image-0.lmp | cut -d " " -f1)
logFiles=$(ls log.lammps.*)
echo "atoms,image-no,energy">energy-path.csv
for logFile in $logFiles; do
grep "Energy initial, next-to-last" ./${logFile} -A 1 | tail -1| awk "{print ${natoms}\",\"${logFile/log.lammps./}\",\"\$3}">>energy-path.csv
done

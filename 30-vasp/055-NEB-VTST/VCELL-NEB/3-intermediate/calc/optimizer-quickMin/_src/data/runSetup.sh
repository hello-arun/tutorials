numImages=3
/home/jangira/application/vtst/vtstscripts-1033/nebmake.pl POSCAR-i.vasp POSCAR-f.vasp $numImages
mv "./OUTCAR-i" ./00/OUTCAR
cp "./OUTCAR-f" ./0$((numImages+1))/OUTCAR

sed -i "s/__IMAGES/${numImages}/" INCAR
sbatch runNEB.sbatch
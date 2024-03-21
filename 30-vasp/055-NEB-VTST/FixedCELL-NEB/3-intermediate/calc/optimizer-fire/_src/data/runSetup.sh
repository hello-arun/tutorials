numImages=3
/home/jangira/application/vtst/vtstscripts-1033/nebmake.py POSCAR-i.vasp POSCAR-f.vasp $numImages
mv "./OUTCAR-i" ./00/OUTCAR
cp "./OUTCAR-f" ./0$((numImages+1))/OUTCAR

sbatch runNEB.sbatch
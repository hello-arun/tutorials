VTST_HOME="/home/jangira/application/vtst/vtstscripts-1033"
NUM_IMGs=5
outDIR="./vis"
${VTST_HOME}/nebmake.pl POSCAR-i.vasp POSCAR-f.vasp ${NUM_IMGs}
mkdir -p ${outDIR}
for dir in $(seq 0 $((NUM_IMGs+1))); do
	echo "moving 0${dir}/POSCAR"
	mv 0${dir}/POSCAR ${outDIR}/0${dir}.vasp
	rmdir 0${dir}
done

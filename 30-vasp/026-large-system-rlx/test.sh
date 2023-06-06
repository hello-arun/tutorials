calcDIR=$(pwd)
i=1
echo "">XDATCAR
while ! grep "reached required accuracy" ${calcDIR}/OUTCAR ; do
    cd ${calcDIR}
    if [ -f "${calcDIR}/CONTCAR" ]; then
        cp ${calcDIR}/CONTCAR ${calcDIR}/POSCAR
    fi
    
    #> mpirun command
    # mpirun -np ${SLURM_NPROCS} ${VASP_HOME}/vasp_std  We Do not run this command for testing
        # Instead we run this to simulate
        cat POSCAR > XDATCAR
        echo "POSCAR at Time $i">CONTCAR
        cat CONTCAR >> XDATCAR
        sleep 5
    #
    cp ${calcDIR}/XDATCAR $calcDIR/XDATCAR-$i
    i=$((i+1))
# Again grepping if accuracy reached
grep "reached required accuracy" ${calcDIR}/OUTCAR
done
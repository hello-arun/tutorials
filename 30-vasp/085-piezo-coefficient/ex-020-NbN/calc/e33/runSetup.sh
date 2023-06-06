#!/bin/bash
displacement_along() {
    # Modify the POSCAR/CONTCAR file to apply given displacement
    # 1sr argument is axis; for x use 1 for y use 2
    # 2nd argument is displacement
    # 3rd argument is input file name.
    # 4th argument is output file name.
    # example :
    #   apply displacement 0.02(i.e 2%) along x axis
    #       npr_along x 0.02 POSCAR POSCAR_new
    #   apply displacement 0.03(i.e 3%) along y axis
    #       npr_along y 0.03 POSCAR POSCAR_new
    local axis="1"
    if [ "${1^^}" = "Y" ]; then
        axis="2"
    fi
    local displacement=$2
    local incar=$3
    outcar=$4
    # Get the required line number to make changes
    local line_no=$((2+$axis))
    local length=$(awk "NR == ${line_no} {print \$${axis}}" ${incar})
    local n_length=$(echo "scale = 10; ${length}*(1+$displacement)" | bc -lq)
    awk "NR == ${line_no} {\$${axis} = \"${n_length}\"} {print}" ${incar} >temp
    mv temp ${outcar}
}

srcDIR=$(pwd)
displacements="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15"

for displacement in $displacements ; do 
    calcDIR="${srcDIR}/disp-${displacement}/"
    mkdir -p $calcDIR
    
    cd $srcDIR
    cp KPOINTS INCAR POTCAR grep-pol.sh chgcen.py runCalcPolarization.sbatch $calcDIR/
    cp POSCARS/POSCAR-$displacement $calcDIR/POSCAR
    cd $calcDIR
    sed -i "s/__job_name/disp-${displacement}/" runCalcPolarization.sbatch
    sbatch runCalcPolarization.sbatch
done

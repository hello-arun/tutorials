#!/bin/bash
strain_along() {
    # Modify the POSCAR/CONTCAR file to apply given strain
    # 1sr argument is axis; for x use 1 for y use 2
    # 2nd argument is strain
    # 3rd argument is input file name.
    # 4th argument is output file name.
    # example :
    #   apply strain 0.02(i.e 2%) along x axis
    #       npr_along x 0.02 POSCAR POSCAR_new
    #   apply strain 0.03(i.e 3%) along y axis
    #       npr_along y 0.03 POSCAR POSCAR_new
    local axis="1"
    if [ "${1^^}" = "Y" ]; then
        axis="2"
    fi
    local strain=$2
    local incar=$3
    outcar=$4
    # Get the required line number to make changes
    local line_no=$((2+$axis))
    local length=$(awk "NR == ${line_no} {print \$${axis}}" ${incar})
    local n_length=$(echo "scale = 10; ${length}*(1+$strain)" | bc -lq)
    awk "NR == ${line_no} {\$${axis} = \"${n_length}\"} {print}" ${incar} >temp
    mv temp ${outcar}
}

srcDIR=$(pwd)
strains=$(seq -0.008 0.004 0.008)
axis="x" # "x" or "y"

for strain in $strains ; do 
    calcDIR="${srcDIR}/ep-${axis^^}-${strain}/"
    mkdir -p $calcDIR
    
    cd $srcDIR
    cp KPOINTS POSCAR INCAR POTCAR runCalcPol*.sbatch $calcDIR/

    cd $calcDIR
    strain_along $axis $strain POSCAR POSCAR

    # For Shaheen
    sed -i "s/__jobName/${axis^^}${strain}/" runCalcPolShaheen.sbatch
    sbatch runCalcPolShaheen.sbatch
done

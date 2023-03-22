#!/bin/bash
strain_along() {
    # Modify the INCAR.pw file to apply a given strain along a specified axis.
    # The function takes four arguments:
    #     1. The axis of strain: x, y, or z (1, 2, or 3 respectively).
    #     2. The amount of strain to be applied, given as a decimal (i.e. 0.02 for 2%).
    #     3. The input INCAR file.
    #     4. The output INCAR file (modified by the function).
    #
    # Example usage:
    #     To apply a strain of 2% along the x-axis:
    #         strain_along x 0.02 INCAR-old.pw INCAR-new.pw
    #     To apply a strain of 3% along the y-axis:
    #         strain_along y 0.03 INCAR-old.pw INCAR-new.pw
    #     To apply a strain of 3% along the z-axis:
    #         strain_along z 0.03 INCAR-old.pw INCAR-new.pw
    
    declare -A axisDict=( ["X"]="1" ["Y"]="2" ["Z"]="3")
    local axis=${axisDict["${1^^}"]}
    local strain=$2
    local incar=$3
    local incarNew=$4
    local tempFile=$(mktemp)
    # Get the required line number to make changes
    local line_no=$(awk -v IGNORECASE=1 "/CELL_PARA/ {print NR+${axis}}" ${incar})
    local length=$(awk "NR == ${line_no} {print \$${axis}}" ${incar})
    local n_length=$(echo "scale = 8; ${length}*(1+$strain)" | bc -lq)
    awk "NR == ${line_no} {\$${axis} = \"${n_length}\"} {print}" ${incar} > $tempFile
    mv $tempFile ${incarNew}
}


srcDIR=$(pwd)
strains=$(seq -0.01 0.002 0.01)
axis="z" # "either [x|y|z]
for strain in $strains ; do 
    calcDIR="${srcDIR}/ep-${axis^^}-${strain}/"
    mkdir -p $calcDIR
    
    cd $srcDIR
    potentials="Al.pz-n-rrkjus_psl.0.1.UPF  B.pz-n-rrkjus_psl.0.1.UPF  N.pz-n-rrkjus_psl.0.1.UPF"
    cp $potentials INCAR-relax.pw INCAR-nscf.pw runCalcPolarization.sbatch $calcDIR/

    cd $calcDIR
    strain_along $axis $strain INCAR-relax.pw INCAR-relax.pw
    strain_along $axis $strain INCAR-nscf.pw INCAR-nscf.pw

    sed -i "s/__jobName/${axis^^}${strain}/" runCalcPolarization.sbatch
    sbatch runCalcPolarization.sbatch
done

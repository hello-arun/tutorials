#!/bin/bash

# Calculation script for applying strain and submitting jobs.
# This script is intended to be executed by ../run.sh, which should call it as:
#    ./runSetup.sh <strainAxis> <strainValues>
#
# Arguments:
#   strainAxis   - Specifies the axis along which strain will be applied ("x" or "y").
#   strainValues - Space-separated list of strain values to apply.
#                  These values are passed directly from ../run.sh.

axis="$1"     # Strain axis, passed from ../run.sh
shift         # Shift arguments to access strain values
strains="$@"  # Remaining arguments as strain values, passed from ../run.sh

srcDIR=$(pwd) 

strain_along() {
    # Function to modify a POSCAR/CONTCAR file to apply a specified strain along a given axis.
    #
    # Arguments:
    #   $1 - Axis along which to apply the strain. Use "x" for the x-axis or "y" for the y-axis.
    #   $2 - Strain value (as a decimal, e.g., 0.02 for a 2% strain).
    #   $3 - Input file name (e.g., POSCAR) containing the original lattice parameters.
    #   $4 - Output file name to save the modified lattice parameters.
    #
    # Example usage:
    #   Apply 2% strain along the x-axis:
    #       strain_along x 0.02 POSCAR POSCAR_modified
    #
    #   Apply 3% strain along the y-axis:
    #       strain_along y 0.03 POSCAR POSCAR_modified

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


for strain in $strains ; do 
    calcDIR="${srcDIR}/${strain}/"
    mkdir -p $calcDIR || { echo "Failed to create ${calcDIR}"; exit 1; }
    
    cd $srcDIR
    cp KPOINTS POSCAR INCAR POTCAR runCalcPol*.sbatch $calcDIR/

    cd $calcDIR
    strain_along $axis $strain POSCAR POSCAR

    # For Shaheen
    sed -i "s/__jobName/${axis^^}${strain}/" runCalcPolShaheen.sbatch
    sbatch runCalcPolShaheen.sbatch
done

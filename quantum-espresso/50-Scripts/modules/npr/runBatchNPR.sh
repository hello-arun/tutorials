#!/bin/bash -e

# This script try to do Poisson's ratio calculation with changing different values of quantity

quantity="eamp"                              # The variable in the scf file to change valeus you can name it random  to calculate without any change
values="0.000 0.008 0.016 0.014 0.012 0.004" # When you want to calculate without any change just put any single value here
axis=X                                       # axis along which to calculate poission ratio XY means along both of them
strains=$(seq -2 0.5 2)                      # FIRST INCREMENT LAST ( Values are in percentages)
# values=$(awk ' BEGIN { for( i = 0; i <= 10 ; i+=2) {x=x" "sprintf("%0.4f",i*0.001)} print(x) }')

scriptDIR=$PWD # current script DIR
cd ../../      # Go to Project DIR
source ./setGlobalVariable.sh

ppDIR="$resultDIR/npr/$quantity"

cd $projectDIR
mkdir -p $ppDIR

for value in $values; do
    # Generating new calculation directory
    n_calcDIR=$calcDIR/$quantity/$value
    mkdir -p $n_calcDIR

    # Generating required input files
    sed "s/${quantity}.*/${quantity} = ${value} ! Hartree unit/" $initDIR/relax.in >$n_calcDIR/relax.in
    # awk -v value="$value" -v quantity="$quantity" '$0 ~ quantity {$3 = value} {print}' $initDIR/relax.in > $n_calcDIR/relax.in

    # Generating additional script files to execute later
    mkdir -p $calcDIR/$quantity/$value/src
    cp $scriptDIR/baseFiles/* $calcDIR/$quantity/$value/src/

    # Executing Script
    cd $calcDIR/$quantity/$value/src/
    job_details=$(sbatch run_initial_relaxation.sbatch $axis "$strains")

    # Final Logging if everything happen smoothly
    touch $ppDIR/list.dat
    if [ -z "$(grep "^$value$" $ppDIR/list.dat)" ]; then
        echo $value >>$ppDIR/list.dat
    fi
    echo -e "$quantity $value \n${job_details}\n" >>$scriptDIR/jobs.log
done

echo -e "\n# ----> END.. <----\n" >>$scriptDIR/jobs.log

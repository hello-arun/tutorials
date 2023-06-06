#!/bin/bash

<<Usage
Created by Arun Jangir, KAUST 
This programm will perform VASP calculation as specified in init/INCAR file at different 'values'
of 'quantity'. For each of these step then it will apply strains along the specified axis and do 
calculations. 

If strain is not needed then change the parameters accordingly. 
axis=""
strains=""
Usage

quantity="EFIELD"           # The variable in the INCAR file that changes
values="0.0 0.4 0.8"        # Different values to perform calc.
axis="x"                    # axis along which to apply strains. For calc along both the axis `xy`
strains=$(seq -2.0 0.5 2.0) # FIRST INCREMENT LAST ( Values are in percentages)

scriptDIR=$PWD # current script DIR
cd ../../      # Go to Project DIR
export projectDIR=$PWD
export srcDIR=${projectDIR}/src
export initDIR=${projectDIR}/init
export resultDIR=${projectDIR}/results
export calcDIR=${projectDIR}/calc

# npr = negative poisson ratio
# ppDIR will store final postProcessed results
ppDIR="${resultDIR}/npr/${quantity}"
mkdir -p ${ppDIR}

for value in ${values}; do
    # generating new calculation directory
    n_calcDIR=${calcDIR}/${quantity}/${value}
    mkdir -p ${n_calcDIR}

    # copying required input files
    required_files="INCAR POSCAR POTCAR OPTCELL"
    cd ${initDIR}
    cp ${required_files} ${n_calcDIR}/
    exit_code=$?
    if [ ${exit_code} -ne 0 ]; then
        echo -e "error...\nFailed reading ${required_files}\nFrom ${initDIR}\nExit code ${exit_code}"
        exit 1
    fi

    # modifying copied input files
    sed -i "s/${quantity}.*/${quantity} = ${value} # eV\/Ang/" ${n_calcDIR}/INCAR 

    # copying additional script files to execute later
    mkdir -p ${n_calcDIR}/src
    cp ${scriptDIR}/baseFiles/* ${n_calcDIR}/src/

    # executing script
    cd ${n_calcDIR}/src/
    job_details=$(sbatch run_initial_relaxation.sbatch ${axis} "${strains}")

    # final logging if everything happen smoothly
    touch ${ppDIR}/list.dat
    grep "^${value}$" ${ppDIR}/list.dat    
    if [ $? -ne 0 ]; then
        echo ${value} >>${ppDIR}/list.dat
    fi
    echo -e "${quantity} ${value} \n${job_details}\n" >>${scriptDIR}/jobs.log
done
echo -e "\n# ----> END.. <----\n" >>${scriptDIR}/jobs.log

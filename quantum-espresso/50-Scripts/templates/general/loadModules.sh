#!/bin/bash
set -e
# This scirpt load various modules into the project folder for computation
# Based on the working env change the module directory here
source ./setGlobalVariable.sh
mkdir -p $projectDIR $initDIR $srcDIR $resultDIR $calcDIR

modueleDIR=/ibex/scratch/jangira/qe/npr/ZScripts/modules
modules=($(ls $modueleDIR/))
len=${#modules[@]}
len=$(expr $len - 1)

for i in $(seq 0 $len); do
    echo "$i : ${modules[$i]} module"
done

read -p "Input Selection : " module_ids

for id in $module_ids; do
    module_name=${modules[$id]}
    echo "Copying...${module_name}"
    mkdir -p $srcDIR
    cp -r $modueleDIR/${module_name} $srcDIR/
    echo "Copy done...${module_name}"
    if [ -f $modueleDIR/${module_name}/README.MD ]; then
        cat $modueleDIR/${module_name}/README.MD
    fi
    echo -e "\n---------><------------\n"
done

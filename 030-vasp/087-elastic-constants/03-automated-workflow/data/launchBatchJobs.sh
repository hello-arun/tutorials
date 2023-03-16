wd=$(pwd)
cDIRs=$(ls -d C*)
i=1
for cDIR in $cDIRs; do
    cd ${wd}/${cDIR}
    echo "id for ${cDIR} is $i"
    strainDIRs=$(ls -d strain_*)
    for strainDIR in $strainDIRs; do
        jobDIR=${wd}/${cDIR}/$strainDIR
        cp ${wd}/run.sbatch ${jobDIR}/
        sed -i "s/__jobName/$i-$strainDIR/" ${jobDIR}/run.sbatch
        cd ${jobDIR}
        echo -e "\nLaunched from $jobDIR\nJob Id $i-$strainDIR\n"
        sbatch run.sbatch
    done
    i=$((i+1))
done
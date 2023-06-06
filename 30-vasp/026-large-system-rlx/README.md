
## How-to-do
When you need to relaxa large system it may be possible that sometimes the relaxation criteria do not complete in the given time. In that case you can use this stretegy to run the simulation for limited number of steps say 50 or 25 and then check if the relaxation is reached. If relaxation is reached then okay continue the job, you need to ask for very long time to do so. Here is an example

```bash
#!/bin/bash
#SBATCH --nodes=20
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH --constraint="intel"
#SBATCH --job-name=LargeSysRlx
#SBATCH --output=std.out
#SBATCH --error=std_%j.err
#SBATCH --time=30:00:00

# loading modules:
module load intel/2016
module load openmpi/4.0.3_intel
export VASP_HOME=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin

calcDIR=$(pwd)
i=1
while ! grep "reached required accuracy" ${calcDIR}/OUTCAR ; do
    cd ${calcDIR}
    if [ -f "${calcDIR}/CONTCAR" ]; then
        cp ${calcDIR}/CONTCAR ${calcDIR}/POSCAR
    fi
    
    #> mpirun command
    mpirun -np ${SLURM_NPROCS} ${VASP_HOME}/vasp_std  
    cp ${calcDIR}/XDATCAR $calcDIR/XDATCAR-$i
    i=$((i+1))
# Again grepping if accuracy reached
grep "reached required accuracy" ${calcDIR}/OUTCAR
done
```

## Test
I have also included a test script you can run it by `bash test.sh` in terminal. 
This test will continue to generate XDATCAR file and CONTCAR file untill in finds the string `reached required accuracy` in the `OUTCAR` file. 
You can write this text manually and the calculation will stop after that.
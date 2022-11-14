#!/bin/bash
#==========================================================#
mkdir get_outcar
cd get_outcar
 #
 # copy the input files and the Slurm jobscript template
 cp ../../input_template/INCAR ./
 cp ../../input_template/POSCAR ./
 cp ../../input_template/POTCAR ./
 cp ../../input_template/KPOINTS ./KPOINTS
 cp ../../input_template/z_jobs_vasp ./
 #
 # comment off the parameters if they exist in INCAR
 sed -i "s/NELM/!NELM/g" INCAR
 sed -i "s/KPAR/!NPAR/g" INCAR
 sed -i "s/NPAR/!NPAR/g" INCAR
 sed -i "s/NCORE/!NCORE/g" INCAR
 #
 # set the following parameters in INCAR
 echo "NELM = 1" >> INCAR
 echo "KPAR = 1" >> INCAR
 echo "NCORE = 1" >> INCAR
 #
 # set the following parameters in the Slurm jobscript
 sed -i "s/__nodes__/1/" z_jobs_vasp
 sed -i "s/__ntasks__/32/" z_jobs_vasp
 sed -i "s/srun/timeout 10s srun/" z_jobs_vasp
 #
 # submit the job
 sbatch z_jobs_vasp
cd ..
#==========================================================#

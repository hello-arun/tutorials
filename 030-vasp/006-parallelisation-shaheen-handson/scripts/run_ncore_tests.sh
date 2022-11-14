#!/bin/bash
#==========================================================#
#---  parameters to be set  -------------------------------#
ncores_per_node=32 # the number of cores per node on Shaheen
ncore_list=(32 16 8) # the list of NCORE to be tested
nodes_list=(1 2 4 8 16 32 64) # the list of the number of nodes to be tests
#----------------------------------------------------------#
# loop over "ncore"
for ncore in ${ncore_list[@]}; do
 #
 # loop over "nodes"
 for nodes in ${nodes_list[@]}; do
  ntasks=$((nodes*ncores_per_node))
  mkdir ncore_${ncore}_nodes_${nodes}
  cd ncore_${ncore}_nodes_${nodes}
   #
   # copy the input files and the Slurm jobscript template
   cp ../../input_template/INCAR ./
   cp ../../input_template/POSCAR ./
   cp ../../input_template/POTCAR ./
   cp ../../input_template/KPOINTS_1kpt ./KPOINTS
   cp ../../input_template/z_jobs_vasp ./
   #
   # comment off the parameters if they exist in INCAR
   sed -i "s/LCHARG/!LCHARG/g" INCAR
   sed -i "s/LWAVE/!LWAVE/g" INCAR
   sed -i "s/NELM/!NELM/g" INCAR
   sed -i "s/ISIF/!ISIF/g" INCAR
   sed -i "s/KPAR/!NPAR/g" INCAR
   sed -i "s/NPAR/!NPAR/g" INCAR
   sed -i "s/NCORE/!NCORE/g" INCAR
   #
   # set the following parameters in INCAR
   echo "LCHARG = .FALSE." >> INCAR
   echo "LWAVE = .FALSE." >> INCAR
   echo "NELM = 1" >> INCAR
   echo "ISIF = 0" >> INCAR
   echo "KPAR = 1" >> INCAR
   echo "NCORE = ${ncore}" >> INCAR
   #
   # set the following parameters in the Slurm jobscript
   sed -i "s/__nodes__/${nodes}/" z_jobs_vasp
   sed -i "s/__ntasks__/${ntasks}/" z_jobs_vasp
   #
   # submit the job
   sbatch z_jobs_vasp
   sleep 1
  cd ..
 done
done
#==========================================================#

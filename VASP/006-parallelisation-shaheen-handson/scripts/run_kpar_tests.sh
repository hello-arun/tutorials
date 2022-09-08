#!/bin/bash
#==========================================================#
#---  parameters to be set  -------------------------------#
ncores_per_node=32 # the number of cores per node on Shaheen
ncore_opt=32 # optimal NCORE value determined from the previous scalability test for NCORE
nodes_1kpt=2 # number of nodes for 1 k-point determined based on the assessment of the previous scalability test for NCORE
nkpoints=18 # number of k-points obtained from OUTCAR
#----------------------------------------------------------#
# generate a list of kpar values and remove the kpar values that are clearly not optimal
for kpar0 in $(eval echo {1..$nkpoints}); do
 kptmax=$(((nkpoints-1)/kpar0+1))
 kpar=$(((nkpoints-1)/kptmax+1))
 if [[ ${kpar} -ne ${kpar0} ]]; then 
  continue
 fi
 kpar_list+=(${kpar})
done
#----------------------------------------------------------#
# loop over "kpar"
for kpar in ${kpar_list[@]}; do
 nodes=$((kpar*nodes_1kpt))
 ntasks=$((nodes*ncores_per_node))
 mkdir kpar_${kpar}_nodes_${nodes}
 cd kpar_${kpar}_nodes_${nodes}
  #
  # copy the input files and the Slurm jobscript template
  cp ../../input_template/INCAR ./
  cp ../../input_template/POSCAR ./
  cp ../../input_template/POTCAR ./
  cp ../../input_template/KPOINTS ./KPOINTS
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
  echo "KPAR = ${kpar}" >> INCAR
  echo "NCORE = ${ncore_opt}" >> INCAR
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
#==========================================================#

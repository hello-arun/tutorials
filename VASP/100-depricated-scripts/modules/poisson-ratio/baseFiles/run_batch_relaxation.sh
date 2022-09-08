#!/bin/bash -e

# Method for strain automation
nprAlong() {
  for strain in $strains; do
    # collecting input
    axis=$1
    axis_id=${axes_dict[$axis]}

    # echo some info for debug
    echo -e "
axis   : ${axis}, id : ${axis_id}
strain : ${strain}"

    # creating new calc_DIR for strain calculation
    n_calcDIR=$srcDIR/relax_${axis}_${strain}
    mkdir -p $n_calcDIR

    # Collecting required input files
    cd $srcDIR
    cp INCAR POTCAR OPTCELL $n_calcDIR/
    cp CONTCAR $n_calcDIR/POSCAR
    cd $n_calcDIR

    # Updating POSCAR and OPTCELL FILE
    python $scriptDIR/gen_strained_POSCAR.py $axis $strain $srcDIR/CONTCAR $n_calcDIR/POSCAR
    sed -i "s/./0/$axis_id" ${n_calcDIR}/OPTCELL

    <<old_code
    marker=$(echo "${axis_id}+2" | bc -lq)
    length=$(awk "NR == ${marker} {print \$${axis_id}}" ${n_calcDIR}/POSCAR)
    n_length=$(echo "scale = 6; ${length}*( 1 + $strain/100)" | bc -lq)
    awk "NR == ${marker} {\$${axis_id} = ${n_length}} {print} " ${n_calcDIR}/POSCAR >POSCAR_temp.in
    mv POSCAR_temp.in ${n_calcDIR}/POSCAR
old_code

    # generating script file to run do calculation
    cat >$n_calcDIR/run_relax.sbatch <<EOF
#!/bin/bash -e
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH --constraint="intel"
#SBATCH --job-name=rlx_${axis}_${strain}
#SBATCH --output=std.out
#SBATCH --error=std_%j.err
#SBATCH --time=2:00:00
#SBATCH --mail-user=arun.jangir@kaust.edu.sa
#SBATCH --mail-type=ALL
# loading modules:
module load intel/2016
module load openmpi/4.0.3_intel
export VASP_HOME=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin

echo -e "
Job id : \${SLURM_JOB_ID}
Cores  : \${SLURM_NPROCS}
Nodes  : \${SLURM_JOB_NODELIST}
"
mpirun -np \${SLURM_NPROCS} \${VASP_HOME}/vasp_std
EOF
    cd $n_calcDIR
    sbatch run_relax.sbatch

    # If reached so far loggin the strain info
    logfile=$srcDIR/strain_${axis}_list.dat
    touch $logfile
    if [ -z $(grep "^$strain$" $logfile) ]; then
      echo $strain >>$logfile
    fi
  done
}

axes=${1,,} # lower case the input axes
strains=$2  # strains (percentage)
scriptDIR=$PWD
cd ../
srcDIR=$PWD

# declare a dict for later use
declare -A axes_dict
axes_dict[x]=1
axes_dict[y]=2
axes_dict[z]=3

if [[ "$axes" =~ .*"x".* ]]; then
  nprAlong x
fi
if [[ "$axes" =~ .*"y".* ]]; then
  nprAlong y
fi
if [[ "$axes" =~ .*"z".* ]]; then
  nprAlong z
fi

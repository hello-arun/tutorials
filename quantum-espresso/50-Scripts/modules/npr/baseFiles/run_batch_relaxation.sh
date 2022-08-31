#!/bin/bash -e

find_and_replace() {
  # First Argument is old relax.in
  # Second in relax.out file contained relaxed coordinates
  # output file where to where to write
  tempfile=asdlhgfasdl
  o_start=$(awk '/Begin final/ {print NR}' $2)
  o_end=$(awk '/End final/ {print NR}' $2)
  i_start=$(awk '/CELL_PARA/ {print NR}' $1)
  awk -v i_start="$i_start" 'NR<=i_start{print}' $1 >$tempfile
  awk -v o_start="$o_start" -v o_end="$o_end" 'NR>4+o_start && NR<o_end {print}' $2 >>$tempfile
  echo "" >>$tempfile
  mv $tempfile $3
}

nprAlong() {
  for strain in $strains; do
    axis=$1
    logfile=$srcDIR/strain_${axis}_list.dat
    touch $logfile
    if [ -z $(grep "^$strain" $logfile) ]; then
      echo $strain >>$logfile
    fi
    n_calcDIR=$srcDIR/relax_${axis}_${strain}
    mkdir -p $n_calcDIR
    cd $n_calcDIR
    # getting equillibrium relax.in file
    find_and_replace $srcDIR/relax.in $srcDIR/relax.out $n_calcDIR/relax.in

    # modifying file to apply strain
    axis_order="xy"
    axis_id=$(echo "a=\" xyz\" ; print(a.index(\"${axis}\"))" | python)
    marker=$(awk -v axis_id="${axis_id}" '/CELL_PARA/ {print NR+axis_id}' ${n_calcDIR}/relax.in)
    length=$(awk "NR == ${marker} {print \$${axis_id}}" ${n_calcDIR}/relax.in)
    n_length=$(echo "scale = 6; ${length}*( 1 + $strain/100)" | bc -lq)
    sed -i "s/cell_dofree.*/cell_dofree = \"${axis_order/$axis/}\"/" ${n_calcDIR}/relax.in
    awk "NR == ${marker} {\$${axis_id} = ${n_length}} {print} " ${n_calcDIR}/relax.in >temp.in
    mv temp.in ${n_calcDIR}/relax.in
    # generating script file to run do calculation
    cat >$n_calcDIR/run_relax.sbatch <<EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH -J relax_$axis$strain
#SBATCH -o std.out
#SBATCH -e std_%j.err
#SBATCH --time=2:00:00
#SBATCH --constraint="intel"
module load quantumespresso/6.6
mpirun -np \${SLURM_NPROCS} pw.x -i relax.in > relax.out
EOF
    sbatch run_relax.sbatch
  done
}

axiss=$1   # axiss along which to apply strains
strains=$2 # strains (percentage)
scriptDIR=$PWD
cd ../
srcDIR=$PWD

if [[ "$axiss" =~ .*"X".* ]]; then
  nprAlong x
fi
if [[ "$axiss" =~ .*"Y".* ]]; then
  nprAlong y
fi
if [[ "$axiss" =~ .*"Z".* ]]; then
  nprAlong z
fi

#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jObName"
#SBATCH --constraint=intel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=0:20:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive

# On IBEX
    module load quantumespresso/6.6

# On Local HPC
    # module load quantum-espresso/6.4.1/intel-19.1.0.166-mkl-openmpi-m2l27zt  
    # SLURM_NPROCS=24

# Initial SCF run 
mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-scf.pw > OUTCAR-scf.pw
# NSCF run for berry phase
mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-nscf.pw > OUTCAR-nscf.pw

find_and_replace() {
    # 1st argument old INCAR.pw
    # 2nd argument relaxed OUTCAR.pw file containing relaxed coords
    # output file where to write relaxed cord file
    # Example :
    #   find_and_replace INCAR.pw OUTCAR.pw ./new-cal-dir/INCAR.pw
    # new-cal-dir must exist before running this code

    o_start=$(awk '/Begin final/ {print NR}' $2)
    o_end=$(awk '/End final/ {print NR}' $2)
    i_start=$(awk '/CELL_PARA/ {print NR}' $1)
    awk -v i_start="$i_start" 'NR<=i_start{print}' $1 >temp
    awk -v o_start="$o_start" -v o_end="$o_end" 'NR>4+o_start && NR<o_end {print}' $2 >>temp
    echo "" >>temp
    mv temp $3
}

strains=$(seq -0.01 0.005 0.01)
srcDIR=$(pwd)

strain_along() {
    # Modify inplace an INCAR.pw file to apply required strain
    # 1sr argument is axis; for x use 1 for y use 2
    # 2nd argument is strain
    # 3rd argument is file name.
    # example :
    #   apply strain 0.02(i.e 2%) along x axis
    #       npr_along 1 0.02 INCAR.pw
    #   apply strain 0.03(i.e 3%) along y axis
    #       npr_along 2 0.03 INCAR.pw

    axis=$1
    strain=$2
    incar=$3
    # Get the required line number to make changes
    line_no=$(awk "/CELL_PARA/ {print NR+${axis}}" ${incar})
    length=$(awk "NR == ${line_no} {print \$${axis}}" ${incar})
    n_length=$(echo "scale = 10; ${length}*(1+$strain)" | bc -lq)
    awk "NR == ${line_no} {\$${axis} = \"${n_length}\"} {print}" ${incar} >temp
    mv temp ${incar}
}


# create a temperory jobscript file
cat >$srcDIR/temprun.sbatch <<\EOF
#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jobName"
#SBATCH --constraint=intel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=0:20:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive

# On IBEX
    module load quantumespresso/6.6

# On Local HPC
    # module load quantum-espresso/6.4.1/intel-19.1.0.166-mkl-openmpi-m2l27zt  
    # SLURM_NPROCS=24

# Initial SCF run 
mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-scf.pw > OUTCAR-scf.pw
# NSCF run for berry phase
mpirun -np ${SLURM_NPROCS} pw.x -i INCAR-nscf.pw > OUTCAR-nscf.pw
EOF

source /ibex/scratch/jangira/root/sbatchh.sh

grep "Begin final" OUTCAR-scf.pw
if [[ $? -eq 0 ]]; then
    for strainX in $strains; do
            n_calc_dir=${srcDIR}/ep_x${strainX}
            mkdir -p ${n_calc_dir}
            # get relaxed cord-file
            # Since NSCF file ignore unit cell and cord file so we only need to replace scf file
            find_and_replace $srcDIR/INCAR-scf.pw $srcDIR/OUTCAR-scf.pw $n_calc_dir/INCAR-scf.pw
            strain_along 1 $strainX $n_calc_dir/INCAR-scf.pw

            # Made some required changes
            sed -i "\
            s/vc-relax/relax/; \
            s/cell_dofree/! cell_dofree/" $n_calc_dir/INCAR-scf.pw

            # Copy Force field and nscf files 
            cp $srcDIR/INCAR-nscf.pw $srcDIR/B_pbe_v1.01.uspp.F.UPF $srcDIR/N.oncvpsp.upf $n_calc_dir
            cp $srcDIR/temprun.sbatch $n_calc_dir/run.sbatch
            sed -i "s/__jobName/X${strainX}/" $n_calc_dir/run.sbatch
            cd $n_calc_dir
            sbatchh run.sbatch
            cd $srcDIR
            # create a run.sbatch file on the fly
    done
fi


# Remove any temperory files created 
rm $srcDIR/temprun.sbatch
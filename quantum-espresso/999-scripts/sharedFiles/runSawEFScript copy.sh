#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=26
#SBATCH --partition=batch
#SBATCH -J Job1
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=1:30:00
#SBATCH --constraint=[cascadelake|skylake]
#run the application:

find_and_replace() {
    # First Argument is base file
    # Second in refernce file
    # 3rd Argument is output file
    tempfile=tempppp
    o_start=$(awk '/Begin final/ {print NR}' $2)
    o_end=$(awk '/End final/ {print NR}' $2)
    i_start=$(awk '/CELL_PARA/ {print NR}' $1)
    awk -v i_start="$i_start" 'NR<=i_start{print}' $1 >$tempfile
    awk -v o_start="$o_start" -v o_end="$o_end" 'NR>4+o_start && NR<o_end {print}' $2 >>$tempfile
    echo "" >>$tempfile
    mv $tempfile $3
}

SCRIPT_DIR=$PWD
PREFIX=$(awk '/PREFIX/ {print $3}' base.sh)

cd ../
SRC_DIR=$PWD

module load quantumespresso/6.6
module load python/3.7.0

for eamp in $(awk ' BEGIN { for( i = 2; i < 21 ; i+=2) {x=x" "sprintf("%0.4f",i*0.001)} print(x) }'); do
    awk -v eamp="$eamp" '/eamp/ { $3 = eamp } {print $0} ' $PREFIX.relax.in >$PREFIX.relax.ef_$eamp.in
    awk -v eamp="$eamp" '/eamp/ { $3 = eamp } /calculation/ { $3= "\"scf\""} {print $0} ' $PREFIX.relax.in >$PREFIX.scf.ef_$eamp.in
    awk -v eamp="$eamp" '/eamp/ { $3 = eamp } {print $0} ' $PREFIX.bands.in >$PREFIX.bands.ef_$eamp.in
    cat >bands.in <<EOF
&BANDS
    outdir  = './out'
    filband = '$PREFIX.bands.ef_$eamp'
/
EOF

    mpirun -np 26 pw.x <$PREFIX.relax.ef_$eamp.in >$PREFIX.relax.ef_$eamp.out
    find_and_replace $PREFIX.scf.ef_$eamp.in $PREFIX.relax.ef_$eamp.out $PREFIX.scf.ef_$eamp.in
    find_and_replace $PREFIX.relax.in $PREFIX.relax.ef_$eamp.out $PREFIX.relax.in
    find_and_replace $PREFIX.bands.ef_$eamp.in $PREFIX.relax.ef_$eamp.out $PREFIX.bands.ef_$eamp.in

    mpirun -np 26 pw.x <$PREFIX.scf.ef_$eamp.in >$PREFIX.scf.ef_$eamp.out

    mpirun -np 26 pw.x <$PREFIX.bands.ef_$eamp.in >$PREFIX.bands.ef_$eamp.out

    ef=$(awk '/highest occupied/ || /Fermi/ {print $(NF-1)}' $PREFIX.scf.ef_$eamp.out)
    mpirun -np 1 bands.x <bands.in >bands.ef_$eamp.out

    (echo "# $ef" && cat $PREFIX.bands.ef_$eamp.gnu) >temp.txt && mv temp.txt $PREFIX.bands.ef_$eamp.gnu

    python $SCRIPT_DIR/Bands.py $PREFIX.bands.ef_$eamp.gnu $ef bands.ef_$eamp.out $PREFIX.ef_$eamp

done

moudle purge python/3.7.0
moudel purge quantumespresso/6.6

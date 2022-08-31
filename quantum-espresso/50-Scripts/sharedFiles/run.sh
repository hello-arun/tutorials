#!/bin/bash
commands=$@
echo "Passed commands are:"
echo $commands

PREFIX=`awk '/PREFIX/ {print $3}' ../base.sh`
SCRIPT_DIR=$PWD
cd ../
SRC_DIR=$PWD
cd $SCRIPT_DIR

cat > sbatchRunPw.sh << EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH -J Job1
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=1:30:00
#SBATCH --constraint=[cascadelake|skylake]

PREFIX=\`awk '/PREFIX/ {print \$3}' ../base.sh\`

module load quantumespresso/6.6

for command in $commands
do
mpirun -np \$(nproc) pw.x <$PREFIX.\$command.in> $PREFIX.\$command.out
done

EOF


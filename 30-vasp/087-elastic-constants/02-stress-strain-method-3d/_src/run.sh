wd=$(pwd)
folders=$(ls -d strain_*)

for folder in $folders; do
jobDIR=${wd}/${folder}
cat > ${jobDIR}/run.sbatch <<\EOF
#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jobName"
#SBATCH --constraint=amd
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=0:30:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive

srcDIR=$(pwd)
module load intel/2016
module load openmpi/4.0.3_intel
export VASP_CMD=/ibex/scratch/jangira/vasp/sw/vasp.5.4.4/bin/vasp_std
export OMP_NUM_THREADS=1

mpirun -np ${SLURM_NPROCS} ${VASP_CMD}
EOF

sed -i "s/__jobName/$folder/" ${jobDIR}/run.sbatch
cd ${jobDIR}
sbatch run.sbatch
done
#!/bin/bash

echo "Passed  commands are : "
echo 



#SBATCH -N 1
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH -J Job1
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=1:30:00
#SBATCH --constraint=[cascadelake|skylake]

#run the application:


PREFIX=`awk '/PREFIX/ {print $3}' base.sh`
SCRIPT_DIR=$PWD
cd ../
SRC_DIR=$PWD

module load quantumespresso/6.6


mpirun -np $(nproc) pw.x <$PREFIX.scf.in> $PREFIX.scf.out

# mpirun -np 34 pw.x <$PREFIX.relax.in> $PREFIX.relax.out
# mpirun -np 34 pw.x <$PREFIX.relax.in> $PREFIX.relax.out
# mpirun -np 34 pw.x <$PREFIX.bands.in> $PREFIX.bands.out
# mpirun -np 34 bands.x <bands.in> bands.out
# pp.x <$PREFIX.pp.in> $PREFIX.pp.out
# mpirun -np 34 pw.x <$PREFIX.nscf.in> $PREFIX.nscf.out
# mpirun  -np 34 dos.x <dos.in> dos.out

# mpirun -np 34 projwfc.x <$PREFIX.pdos.in> $PREFIX.pdos.out
# sumpdos.x $PREFIX.pdos.dat.pdos_atm#*Ge*p* > $PREFIX.pdos.Ge.p.dat
# sumpdos.x $PREFIX.pdos.dat.pdos_atm#*Ge*s* > $PREFIX.pdos.Ge.s.dat
# sumpdos.x $PREFIX.pdos.dat.pdos_atm#*S*s* > $PREFIX.pdos.S.s.dat
# sumpdos.x $PREFIX.pdos.dat.pdos_atm#*S*p* > $PREFIX.pdos.S.p.dat
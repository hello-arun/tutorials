#!/bin/bash

quantity="eamp"           #the variable in the scf file to change valeus you can name it random  to calculate without any change
# values="0.00 0.02 0.04"      # when you want to calculate without any change just put any single value here
values=$(awk ' BEGIN { for( i = 0; i <= 4 ; i+=2) {x=x" "sprintf("%0.4f",i*0.001)} print(x) }')

PREFIX=`awk '/^PREFIX/ {print $3}' base.sh`
nproc=`awk '/^np/ {print $3}' base.sh` 
SCRIPT_DIR=$PWD
cd ../
mkdir -p ./postProcessing
for value in $values
do
echo $quantity\_$value >> ./postProcessing/$quantity\_list.sh
mkdir -p $quantity\_$value
awk -v value="$value" -v quantity="$quantity" '$0 ~ quantity {$3 = value} {print}' ./$PREFIX.scf.in > ./$quantity\_$value/$PREFIX.scf.in
awk -v value="$value" -v quantity="$quantity" '$0 ~ quantity {$3 = value} {print}' ./$PREFIX.nscf.in > ./$quantity\_$value/$PREFIX.nscf.in

cat > ./$quantity\_$value/dos.in <<EOF
&DOS
  outdir='./out',
  Emin = -11.5,
  Emax = 9.5,
  DeltaE = 0.1,
  fildos = '$PREFIX.dos.dat',
/
EOF

cat > ./$quantity\_$value/$PREFIX.pdos.in <<EOF
&projwfc
    outdir = "./out"    
    filpdos='$PREFIX.pdos.dat'
/
EOF


cat > ./$quantity\_$value/runPDOS.sh << EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=$nproc
#SBATCH --partition=batch
#SBATCH -J PDOS
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=1:30:00
#SBATCH --constraint=[cascadelake|skylake]
#run the application:



module load quantumespresso/6.6

mpirun -np $nproc pw.x <$PREFIX.scf.in> $PREFIX.scf.out
mpirun -np $nproc pw.x <$PREFIX.nscf.in> $PREFIX.nscf.out
mpirun -np $nproc projwfc.x <$PREFIX.pdos.in> $PREFIX.pdos.out
mpirun -np $nproc dos.x <dos.in> dos.out


# sumpdos.x $PREFIX.pdos.dat.pdos_atm#*Ge*p* > $PREFIX.pdos.Ge.p.dat
# sumpdos.x $PREFIX.pdos.dat.pdos_atm#*Ge*s* > $PREFIX.pdos.Ge.s.dat
# sumpdos.x $PREFIX.pdos.dat.pdos_atm#*S*s* > $PREFIX.pdos.S.s.dat
# sumpdos.x $PREFIX.pdos.dat.pdos_atm#*S*p* > $PREFIX.pdos.S.p.dat

EOF

cd ./$quantity\_$value
echo "$quantity\_$value" >> ../ZScripts/jobs.sh 
sbatch runPDOS.sh >> ../ZScripts/jobs.sh
echo " " >> ../ZScripts/jobs.sh 
cd ..
done
#!/bin/bash
quantity="eamp"   # The variable in the scf file to change values you can name it random  to calculate without any change
values="0.000 0.0028 0.0057 0.0085 0.0113 0.0142 0.0156"
# When you want to calculate without any change just put any single value here
# nproc=`awk '/^np/ {print $3}' base.sh` 
scriptDIR=$PWD
srcDIR=$scriptDIR/../
ppDIR=$srcDIR/postProcessing/
outDIR=$ppDIR/$quantity
mkdir -p $outDIR 
for value in $values
do
cwd=$srcDIR/$quantity/$value
mkdir -p $cwd
echo ${value} >> $ppDIR/${quantity}/list.sh
awk -v value="$value" -v quantity="$quantity" '$0 ~ quantity {$3 = value} {print}' $srcDIR/scf.in > $cwd/scf.in

cat > ${cwd}/charge.pp0.in <<EOF
&inputpp
outdir = './out'
filplot = 'charge0'
plot_num = 0
/
&plot
nfile = 1
filepp(1) = 'charge0'
weight(1) = 1.0
iflag = 3
output_format = 6
fileout = 'chargeDensity0.cube'
/
EOF
cat > $cwd/charge.pp21.in <<EOF
&inputpp
outdir = './out'
filplot = 'charge21'
plot_num = 21
/
&plot
nfile = 1
filepp(1) = 'charge21'
weight(1) = 1.0
iflag = 3
output_format = 6
fileout = 'chargeDensity21.cube'
/
EOF

cat > $cwd/runChargeDiff.sh <<EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=24
#SBATCH --partition=batch
#SBATCH -J Ch_Dens
#SBATCH -o std_bader.out
#SBATCH -e std_bader.err
#SBATCH --time=0:30:00
##SBATCH --constraint=[cascadelake|skylake]


module load quantumespresso/6.6

# mpirun -np \$(nproc) pw.x <scf.in> scf.out
pp.x <charge.pp0.in> charge.pp0.out
pp.x <charge.pp21.in> charge.pp21.out

# cp charge.ef_$ef ../charge.ef_$ef

mv  chargeDensity0.cube  val_chden.cube
mv  chargeDensity21.cube all_chden.cube
bader val_chden.cube -ref all_chden.cube
EOF
cd $cwd
echo "${quantity}_${value}" >> $scriptDIR/jobs.sh 
sbatch runChargeDiff.sh >> $scriptDIR/jobs.sh
echo " " >> $scriptDIR/jobs.sh 
done

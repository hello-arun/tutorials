#!/bin/bash

quantity="eamp"           #the variable in the scf file to change valeus you can name it random  to calculate without any change
values="0.000 0.004 0.008 0.012 0.014 0.016"      # when you want to calculate without any change just put any single value here
np=24 # No of Processors
plot_num=11

# Some key value pair do not change it
# If you are using any value outside these two please specify the tag below
plot_num_tags[0]="chden"      ## 0 means chden
plot_num_tags[11]="potential" ## 11 means potential 
############################
tag=${plot_num_tags[${plot_num}]}
echo $tag
scriptDIR=$PWD
baseDIR=`readlink -f ../../`
ppDIR=$baseDIR/postProcessing
srcDIR=$baseDIR/$quantity/
outDIR=$ppDIR/$quantity/avg2/$tag/

echo "baseDIR : $baseDIR"
echo "scriptDIR : $scriptDIR"
echo "ppDIR     : $ppDIR"
echo "srcDIR    : $srcDIR"
echo "outDIR    : $outDIR"

echo "----> START <----" >> $scriptDIR/jobs.sh 
echo `date` >> $scriptDIR/jobs.sh 


cd $srcDIR
mkdir -p $outDIR
for value in $values
do
echo $value >> $outDIR/list.sh
mkdir -p $srcDIR/$value/avg_ref_scf
cp $srcDIR/$value/relax.X0.000/relax.in $srcDIR/$value/avg_ref_scf/scf.in
sed -i 's/vc-relax/scf/g' $srcDIR/$value/avg_ref_scf/scf.in
sed -i '8 a dipfield = .true. ' $srcDIR/$value/avg_ref_scf/scf.in
sed -i "s/eamp/eamp = 0.000  !/g" $srcDIR/$value/avg_ref_scf/scf.in

# awk -v value="$value" -v quantity="$quantity" '$0 ~ quantity {$3 = value} {print}' ./scf.in > ./$quantity/$value/scf.in



cat > $srcDIR/$value/avg_ref_scf/pp.avg_$tag.in <<EOF
&INPUTPP
outdir='./out',
plot_num = ${plot_num}
filplot = "avg_$tag"
/
EOF

cat > $srcDIR/$value//avg_ref_scf/avg.$tag.in <<EOF
1
avg_$tag
1.D0
150
3
1.000000
EOF

cat > $srcDIR/$value/avg_ref_scf/runAvg_$tag.sh << EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=$np
#SBATCH --partition=batch
#SBATCH -J Avg_Pot
#SBATCH -o Job_Avg_$tag.out
#SBATCH -e Job_Avg_$tag.err
#SBATCH --time=0:15:00
#SBATCH --constraint=[cascadelake|skylake]

#Loading Modules:
module load quantumespresso/6.6

mpirun -np \$(nproc) pw.x <scf.in> scf.out

pp.x <pp.avg_$tag.in> pp.avg_$tag.out
average.x <avg.$tag.in> avg.$tag.out
(awk '/Fermi energy/ || /highest occupied/{ print "#"\$0 }' scf.out  && cat avg.dat ) > temp
mv temp avg_$tag.dat
rm avg.dat
cp avg_$tag.dat $outDIR/$value.dat
EOF

cd $srcDIR/$value/avg_ref_scf
echo "$quantity $value" >> $scriptDIR/jobs.sh 
sbatch runAvg_$tag.sh >> $scriptDIR/jobs.sh
echo " " >> $scriptDIR/jobs.sh 
done
echo "# ------> <------" >> $outDIR/list.sh
echo "----> End <----" >> $scriptDIR/jobs.sh 
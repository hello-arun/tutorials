requiredFiles="pseudo *.in *.win run.sbatch"
dataDIR=${PWD}
cd ../../ex-01-Si-valanceBands/data/
cp -r $requiredFiles $dataDIR/

cd $dataDIR || exit 1 
## Change the number of bands in nscf calculation
mv ex1.win ex2.win
sed -i "s/nbnd.*/nbnd = 12/" 05_nscf.in
sed -i "s/ex1/ex2/" 06_pw2wan.in
sed -i "s/ex1/ex2/" run.sbatch
sed -i \
    -e "s/num_bands.*/num_bands = 12/" \
    -e "s/num_wann.*/num_wann = 8/" \
    -e "24d;26,29d" ex2.win
sed -i \
-e "24i #4-sp3 orbital for each Si" \
-e "25i Si:sp3"  \
-e "5i dis_froz_max = 6.5" \
-e "5i dis_win_max = 17" ex2.win


module load wannier90/3.0.0/openmpi-3.0.0-intel2017
srcDir=${PWD}
rawTutoDir=../../_raw/Mon.4.Pizzi

cp -r $rawTutoDir/ex4/* ./


# # Modify SCF File
for file in $(ls *.in); do 
    sed -i "s;outdir.*;outdir = 'wfc-out/';" $file
done

sed -i "6i \\
   scdm_entanglement = 'erfc' \n\
   scdm_proj = .true. \n\
   scdm_mu = 12.87653 \n\
   scdm_sigma = 1.62839" 06_pw2wan.in

sed -i "s/proj.out/05_proj.out/" generate_weights.sh 
# sed -i "s;out/;\./wfc-out;" 03_bandsx.in
# sed -i "s;out/;\./wfc-out;" 06_pw2wan.in

# ## BANDS FILE
# sed  \
#  -e "s/scf/bands/" \
#  -e '14i \    nbnd            = 12' \
#  -e '17i \    diago_full_acc  =  .true.' \
#  -e '23,24d' 01_scf.in > 02_bands.in

# echo """
# K_POINTS crystal_b
# 3
# 0.5 0.5 0.5 50
# 0.0 0.0 0.0 50
# 0.5 0.0 0.5 50""" >> 02_bands.in

# ## NSCF FILE
# cp 02_bands.in 05_nscf.in
# sed -i \
#  -e "s/bands/nscf/" \
#  -e "s/nbnd.*/nbnd = 4/" \
#  -e "30,34d" 05_nscf.in

# kmesh.pl 4 4 4 >> 05_nscf.in

# ## ex1.win File
# sed -i \
# -e "44,48d" \
# -e "s/num_wann.*/num_wann = 4/" \
# -e "s/num_bands.*/num_bands = 4/" ex1.win

# echo -e """mp_grid  =  4 4 4
# begin kpoints""" >> ex1.win
# kmesh.pl 4 4 4 wannier >> ex1.win
# echo "end kpoints" >> ex1.win



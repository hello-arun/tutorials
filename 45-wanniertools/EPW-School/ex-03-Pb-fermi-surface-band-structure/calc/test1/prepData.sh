module load wannier90/3.0.0/openmpi-3.0.0-intel2017
srcDir=${PWD}
rawTutoDir=../../_raw/Mon.4.Pizzi

cp -r $rawTutoDir/ex3/* ./
# Modify SCF File
sed -i "s;outdir.*;outdir='wfc-out/';" 01_scf.in
sed -i "s;outdir.*;outdir='wfc-out/';" 04_nscf.in
sed -i "s;outdir.*;outdir='wfc-out/';" 05_pw2wan.in

## BANDS FILE
sed  \
 -e "s/scf/bands/" \
 -e '12i \    nbnd            = 13' \
 -e '16i \    diago_full_acc  =  .true.' \
 -e '21,22d' 01_scf.in > 02_bands.in

echo """
K_POINTS crystal_b
6
 0.00  0.00  0.00 40 !G  
 0.50  0.50  0.00 40 !X
 0.50  0.75  0.25 40 !W
 0.00  0.50  0.00 40 !L
 0.00  0.00  0.00 40 !G
 0.00  0.50 -0.50 40 !K""" >> 02_bands.in

  
sed -i "7i \   write_unk = .true." 05_pw2wan.in
# ex3.win File
# Fermi Energy Should be obtained from nscf run
# I have checked it it 11.2195
sed -i \
    -e "1i # Uncomment these lines to post plot bands and fermi" \
    -e "1i #restart         =  plot" \
    -e "1i fermi_energy     =  11.2195" \
    -e "1i fermi_surface_plot   =  true" \
    -e "1i bands_plot       =  true" \
    -e "1i wannier_plot     =  true" \
    -e "1i wannier_plot_supercell =  3" \
    ex3.win
# -e "s/num_wann.*/num_wann = 4/" \
# -e "s/num_bands.*/num_bands = 4/" ex1.win

# echo -e """mp_grid  =  4 4 4
# begin kpoints""" >> ex1.win
# kmesh.pl 4 4 4 wannier >> ex1.win
# echo "end kpoints" >> ex1.win



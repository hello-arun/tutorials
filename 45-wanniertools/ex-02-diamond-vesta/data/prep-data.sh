#!/bin/bash

# This sciript will copy example-5 input files and pseduopotentail as available in wannier90-3.0.0/examples/.
# You can also download the this pseudopotential from http://pseudopotentials.quantum-espresso.org/upf_files/C.pz-vbc.UPF
# After copying those files it will make changes so as to make them compatible with current run.

cp /sw/csi/wannier90/3.0.0/el7.7_openmpi3.0.0/wannier90-3.0.0/examples/example28/* ./
cp /sw/csi/wannier90/3.0.0/el7.7_openmpi3.0.0/wannier90-3.0.0/pseudo/C.pz-vbc.UPF ./

# Update diamond.scf
sed -i \
-e 's;pseudo_dir.*;pseudo_dir="./";' \
-e 's;outdir.*;outdir="./wfc-out";' diamond.scf

# Update diamond.nscf
sed -i \
-e 's;pseudo_dir.*;pseudo_dir="./";' \
-e 's;outdir.*;outdir="./wfc-out";' diamond.nscf

# update diamond.pw2wan
sed -i \
-e 's;outdir.*;outdir="./wfc-out";' \
-e 's;seedname.*;seedname = "INCAR";' diamond.pw2wan

echo -e """
wannier_plot = .true.
wannier_plot_supercell = 3
wannier_plot_format = cube
wannier_plot_mode = crystal
wannier_plot_radius = 2.5
wannier_plot_scale = 1.0
""" >> diamond.win

mv diamond.scf INCAR-scf.pw
mv diamond.nscf INCAR-nscf.pw
mv diamond.pw2wan INCAR.pw2wan
mv diamond.win INCAR.win

# in the end convert to unix format if there are any problem

dos2unix ./*
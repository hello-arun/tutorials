* Downloaded odpa.mol from https://molview.org/?cid=78451
* Converted the mol file to odpa.mol2 and odpa.pdb file using https://www.webqc.org/molecularformatsconverter.php
* Installed the ambertools in a conda environment via pip install command as discussed on https://ambermd.org/GetAmber.php#ambertools

```
 conda create --name AmberTools25 python=3.12 (Only done once.)
 # Next, install the code, which also only needs to be done once:
 conda activate AmberTools25
 conda config --add channels conda-forge
 conda config --set channel_priority strict
 conda install dacase::ambertools-dac=25

 conda activate AmberTools25
 source $CONDA_PREFIX/amber.sh
 
 # cd to some working folder, and run AmberTools programs
 # conda deactivate
```

* Use antechamber command to generate atom types and initial charges

```
antechamber -i odpa.mol2 -fi mol2 -o output.mol2 -fo mol2 -c bcc -s 2
```
 
* Use the utility parmchk2 to test if all the parameters we require are available.

parmchk2 -i output.mol2 -f mol2 -o sustiva.frcmod

* create a file leap.in with following content

```
source leaprc.gaff
mol = loadmol2 output.mol2
loadamberparams output.frcmod
saveamberparm mol prmtop inpcrd
quit
``` 
* Then create topology (forcefield, charges, atom types, bonds etc.) and cordinate file using 

```
tleap -f leap.in
```

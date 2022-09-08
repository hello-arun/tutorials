# Bader Charge in VASP

## IMPORTANT

All files/scripts required can be found in the [./example/data](./example/data) folder except `POTCAR` file you need to generate it yourself as mentioned in [README](./example/data/README.md) file.

## How to do
One major issue with the charge density (CHGCAR) files from the VASP code is that they only contain the valance charge density. The 
Bader analysis assumes that charge density maxima are located at atomic centers (or at pseudoatoms). Aggressive pseudopotentials remove
charge from atomic centers where it is both expensive to calculate and irrelevant for the important bonding properties of atoms.
VASP contains a module (aedens) which allows for the core charge to be written out from PAW calculations. This module is included in 
vasp version 4.6.31 08Feb07 and later. By adding the `LAECHG=.TRUE.` to the INCAR file, the core charge is written to AECCAR0 and the 
valance charge to AECCAR2. These two charge density files can be summed using the chgsum.pl script:

```
module load perl
perl chgsum.pl AECCAR0 AECCAR2
```

The total charge will be written to `CHGCAR_sum`.
The bader analysis can then be done on this total charge density file:

```
chmod +x bader
bader CHGCAR -ref CHGCAR_sum
```
## Output files

| FileName | Content |
| ---: | :--- |
| ACF.dat | BADER atomic charge |
| BCF.dat | BADER volume charges |

One finally note is that you need a fine fft grid to accurately reproduce the correct total core charge. It is essential to do a few calculations, increasing NG(X,Y,Z)F until the total charge is correct.

## Example

Example folder contain bader charge calculation for 2H-MoS2 case.
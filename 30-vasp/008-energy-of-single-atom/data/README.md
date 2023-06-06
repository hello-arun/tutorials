# Input

Input files discription

## POSCAR

```VASP
Potassium atom in a box
 1.0          ! universal scaling parameters
 __vac 0.0 0.0  ! vac to be repalced from run.sh
 0.0 __vac 0.0  ! lattice vector  a(2)
 0.0 0.0 __vac  ! lattice vector  a(3)
1             ! number of atoms
cart          ! positions in cartesian coordinates
 0 0 0
```
We are using a POSCAR file with a single atom. Sufficiently large lattice parameters should be selected  and the same should be carefully examined via some convergence test so that no (significant) interactions between atoms in neighbouring cells is present.

We have used here a variable __vac that need to be replace in
`run.sh` script by `sed`.

## INCAR

```VASP
SYSTEM = O atom in a box
ISMEAR = 0  ! Gaussian smearing
```

## KPOINTS

```VASP
Gamma-point only
 0
Monkhorst Pack
 1 1 1
 0 0 0
```
For atoms or molecules a single k point is sufficient. When more k points are used only the interaction between atoms (which should be zero) is described more accurately.

## POTCAr

Code used to get pseudo pot

```bash
ppDIR=/sw/xc40cle7/vasp/pot54/potpaw_PBE
rm POTCAR
cat $ppDIR/K_pv/POTCAR >>POTCAR
```


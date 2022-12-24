# Tutorial-for-kids

This repository is created to provided neat implementation of some common computations in `LAMMPS`, `QUANTUM ESPRESSO` and `VASP`. Other modules such as `Material Studio` and `SIESTA` may also be added in the future.

Code to automate various caluculation along with some common mistakes and error is included. Content is frequently revised to update the most optimum solution.

## Quick Tips

### Monkhorst-Pack Scheme

1. Quantum Espresso => The generated grid is always gamma centered.
2. VASP => The odd grid is gamma centered while even grid is not.

## Commonly used conversion factors
For extended list click [here](./convFactors.md)
```text
Pressure:
1 eV/Angstrom3 = 160.21766208 GPa
1 Ha/Bohr3 = 29421.02648438959 GPa
1 atm = 1.01325 bar = 0.000101325 GPa
1 GPa = 10 kbar

Force:
1 Ry/Bohr = 25.71104309541616 eV/Angstrom
1 Ha/Bohr = 51.42208619083232 eV/Angstrom

Energy:
1 Hartree = 2 Ryd = 27.211396 eV (nist - 27.21138386)
1 kJ/mol = 0.0103642688 eV/atom
1 Joule = 6.24150965x10^(18) eV (CODATA)
1 eV = 1.6021766208*10^(-19) Joules

Length:
1 Bohr = 0.529177208 Angstrom

Temperature:
kb=(3.166815*10^(-6)) Ha/K = (8.617343*10^(-5)) eV/K
1 eV = kb*T = 11604.505008 K (~10^4 K)
```

## Some useful bash script

### loop over array

```bash
grids=("4 4 1" "8 8 1" "16 16 1" "24 24 1" "16 16 2" "8 8 2")

# By Index
for ((i=0; i < ${#grids[@]}; i++)); do
    grid=${grids[$i]}
    echo $grid
done

# By Item 
for grid in "${grids[@]}"; do
    echo $grid
done
```
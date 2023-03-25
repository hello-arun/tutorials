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

### Declaring dictionary in bash

```bash
declare -A animals=( ["moo"]="cow" ["woof"]="dog")

# How to use
echo ${animals["moo"]}
# output: cow
```

### Ignoring case while matching pattern in awk

calculate the line number containg CELL_PARA in INCAR-scf.pw file while ignoring case

```bash
line_no=$(awk -v IGNORECASE=1 "/CELL_PARA/ {print NR}" INCAR-scf.pw)
```

### Formatting XDATCAR to render inside OVITO

When doing relaxation with `isif=4` in vasp, the trajectory file 'XDATCAR' can not be viewed directly in ovito visualtion software. You have to delete some
initial lines for it to work. you can achieve it by 

```
awk 'NR>7{print}' XDATCAR > XDATCAR_REV
```

### Extracting Detailed Node info

Sometimes the performance across the amd nodes is not consistent. To dive into what is causing the issue you can see detailed infromation about node using 

```bash
# To display complete info about every node
scontrol show node

# To display info about specific node
#    scontrol show node <nodeName>
scontrol show node cn513-05-l

# To see active features you can pipe it into grep 
scontrol show node cn513-05-l | grep  "ActiveFeatures" 
```

Small script to print info about every node used in the calculation. It will read the nodelist from std.out

```bash
#!/bin/bash
nodeList=$(grep "NodeList" std.out | awk '{print $2}')
nodeList=$(echo ${nodeList//,/ })
echo "Node List: $nodeList"
for node in $nodeList; do
    activeFeatures=$(scontrol show node $node| grep "ActiveFeatures")
    echo "$node => $activeFeatures"
done
```

## Worth visiting
* https://chengcheng-xiao.github.io

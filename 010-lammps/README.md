# LAMMPS Tutorials

Various tutorials for LAMMPS. This repo contains short tricks that we generally need to incorporate in bigger projects.


## Some Hacks

### -skiprun

Insert the command `timer timeout 0 every 1` at the beginning of an input file or after a clear command. This has the effect that the entire LAMMPS input script is processed without executing actual run or minimize and similar commands (their main loops are skipped). This can be helpful and convenient to test input scripts of long running calculations for correctness to avoid having them crash after a long time due to a typo or syntax error in the middle or at the end.

## How to Thermostat

This is the most critical part of any molecular dynamic simulation, How to Thermostat? Let us start with simple cases.

### Case 1 : Biaxial Straing of 2D flake

In this case we want to move the boundary atoms with some constant speed so as to apply strain on the system, so how will we handle this simulation? There are different setting that we may opt here for

1. When boundary atoms are completely fixed.
2. When boundary atoms are fixed only along some direction but are free to move along other direction.

In such cases We simulate the whole system as NVE ensemble(To integration their equation of motion so that they can respond to forces applied on them) and then we can control the temperateure of only dynamic part. So it is like **NVE + Brendsen Temperature Control**. This is the most common simulation setting that is frequently used. I will add various such exmaples in the repository soon.

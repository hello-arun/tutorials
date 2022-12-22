# Dipole Correction

## How to do

```vasp
#> Dipole Correction
    LDIPOL = .TRUE.
    IDIPOL = 3
#
```
* You can use vaspkit to move the 2D material to the bottom along z-direciton

## Common problems

### No convergence when dipole correction is switched on.

The detailed problem can be found out at https://www.vasp.at/forum/viewtopic.php?t=13121

#### Solution
* Always keep the center of slab near z=0. ***You can use `vaspkit(option 920)` or `ase gui` to move the 2D material to the bottom along z-direciton.***

* Never keep monolayer in the middle of the simulation cell**

## Reference

1. https://www.vasp.at/forum/viewtopic.php?t=13121
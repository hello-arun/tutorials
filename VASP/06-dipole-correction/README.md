# Dipole Correction

## How to do

```vasp
#> Dipole Correction
    LDIPOL = .TRUE.
    IDIPOL = 3
#
```

## Common problems

### No convergence when dipole correction is switched on.

The detailed problem can be found out at https://www.vasp.at/forum/viewtopic.php?t=13121

#### Solution
**Always keep the center of slab near z=0.**

**Never keep monolayer in the middle of the simulation cell**

**If you do so the calculation will never converge.**

## Reference

1. https://www.vasp.at/forum/viewtopic.php?t=13121
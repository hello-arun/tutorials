We calculate piezoelectric stress coefficient(e_ijk) and strain coefficients(d_ijk) here by modern theory of polarization.
The modern theory of polarization or the Berry phase calculations are initiated by the tag [LBERRY](https://www.vasp.at/wiki/index.php/LBERRY) along with few other params
as mentioned below.

```bash
LBERRY = TRUE   # Turn on the Berry Phase calculations
IGPAR  = 1|2|3  # Direction along which to calculate polarization
NPPSTR = X      # Num of points on string along IGPAR direction
DIPOL  = 0-1 0-1 0-1 # Center of cell along which to calculate dipole in fractional cords.
```
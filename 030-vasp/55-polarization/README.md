*** Needs revision***  
We calculate piezoelectric stress coefficient(e_ijk) and strain coefficients(d_ijk) here by modern theory of polarization.

There are mainly two methods for calculating polarization in vasp. 
* `LBERRY`  
    * Convensional Method similar to `Quantum Espresso`
    * More mature and robust
    * Only Polarization along a perticular direction is calculated as specified by `IGPAR`. In the output we see all three component but
    component as specified by `IGPAR` is correct.
    * Parallelization is supported.
* `LCALCPOL`   
    * Faster method which gives complete polarization vector along all 3 direction. 
    * Parallelization is not supported.

## How to Calculate

After Obtaing the completely relaxed structure the steps for calculating polarization are as follows

### 1. SCF-run  
With sufficiently dense k-mesh grid, obtain charge density and wavefunction (`CHG`, `CHGCAR`, `WAVECAR`) files by doing SCF calculation.

### 2. Continuation-JOB  
Copy `CHG*`, `WAVECAR`, `INCAR`, `POTCAR`, `KPOINTS` etc. to a new folder and modify  `INCAR` file as follows...

```vasp
ISTART = 1 # READ WAVECAR FOR CONTINUATION JOB
ICHARG = 1 # READ CHARGEDENSITY FILE
```
Now steps differ for the two different methods as discussed. We start with easier approach first.  
#### `LCALCPOL` method  
Just add in the `INCAR` file as shown and then run.

```vasp
LCALCPOL = .TRUE.
DIPOL  = 0-1 0-1 0-1 # <Optinal> Center of cell along which to calculate dipole in fractional cords.
```
* You may not need to define `DIPOL`, vasp in that case
itself calc appropriate DIPOL 
#### `LBERRY` method

The modern theory of polarization or the Berry phase calculations are manually initiated by the tag [LBERRY](https://www.vasp.at/wiki/index.php/LBERRY). We only calculate polarization along a perticular direction, so we need to specify few other params as mentioned below.

```vasp
LBERRY = .TRUE.   # Turn on the Berry Phase calculations
IGPAR  = 1|2|3    # Direction along which to calculate polarization
NPPSTR = X        # Num of points on string along IGPAR direction
DIPOL  = 0-1 0-1 0-1 # <Optinal>Center of cell along which to calculate dipole in fractional cords.
```
* `NPPSTR` generally equal to K points in that direction, But convergence need to be checked.  
* You may not need to define `DIPOL`, vasp in that case
itself calc appropriate DIPOL 





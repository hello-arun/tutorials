# **Ab Initio MD**

In [MD](https://en.wikipedia.org/wiki/Molecular_dynamics) simulations, the motion of atoms (or molecules) at a specific temperature is simulated by means of the [classical equation of motion](https://en.wikipedia.org/wiki/Lagrangian_mechanics). In other words, each iteration simulates a time step, where atoms are treated as classical particles subject to forces as in [Newton's second law](https://en.wikipedia.org/wiki/Newton%27s_laws_of_motion). When these forces are computed quantum mechanically using *ab-initio* methods, one speaks of *ab-initio* MD. To employ the [canonical ensemble](https://en.wikipedia.org/wiki/Canonical_ensemble), or [NVT ensemble](https://en.wikipedia.org/wiki/Canonical_ensemble), the calculation must be done at constant number of particles (N), constant volume (V) and constant temperature (T).

To include the effect of temperature, some kind of [thermostat](https://www.vasp.at/wiki/index.php/Category:Thermostats) needs to be included. Methods to achieve that involve modifying the equations of motion either by introducing stochastic or deterministic terms through additional dynamical variables, which mimic the action of a heat bath in a real thermostat. The [Nosé-Hoover thermostat](https://www.vasp.at/wiki/index.php/Nose-Hoover_thermostat) corresponds to the latter. A possible deficiency of the [Nosé-Hoover thermostat](https://www.vasp.at/wiki/index.php/Nose-Hoover_thermostat) is the lack of [ergodicity](https://en.wikipedia.org/wiki/Ergodicity) in small or stiff systems, for instance in the [simulation of a single butane molecule](https://doi.org/10.1021/jp013689i), but it is perfectly suitable for the present example. 

In order to learn more about [MD algorithms in VASP](https://www.vasp.at/wiki/index.php/MDALGO) and how the effect of temperature is included by means of the [Nosé-Hoover thermostat](https://www.vasp.at/wiki/index.php/Nose-Hoover_thermostat) in this calculation, read the linked [VASP Wiki](https://www.vasp.at/wiki/index.php) articles.

## **ex-01-Si-melting-090fs**

*Perform an ab-initio MD simulation for cubic-diamond (cd) silicon for 90fs with 64 atoms in a canonical ensemble using the Nosé-Hoover thermostat at 2000K.*

## **ex-02-Si-melting-180fs**

*Compute the pair-correlation function of melting silicon after 90fs to 180fs by means of an ab-initio MD simulation for cubic-diamond (cd) silicon with 64 atoms in a canonical ensemble using the Nosé-Hoover thermostat at 2000K.*

## **ex-03-Si-melting-195fs**

*Compute the pair-correlation function of melting silicon after 180fs to 195fs by means of an ab-initio MD simulation for cubic-diamond (cd) silicon with 64 atoms in a canonical ensemble using the Nosé-Hoover thermostat at 2000K.*

Copy the latest ionic positions from [CONTCAR](https://www.vasp.at/wiki/index.php/CONTCAR) to [POSCAR](https://www.vasp.at/wiki/index.php/POSCAR) and change the [INCAR](https://www.vasp.at/wiki/index.php/INCAR) file to run for additional 15fs. Check the meaning of [NPACO](https://www.vasp.at/wiki/index.php/NPACO), [APACO](https://www.vasp.at/wiki/index.php/APACO), [NBLOCK](https://www.vasp.at/wiki/index.php/NBLOCK) and [KBLOCK](https://www.vasp.at/wiki/index.php/KBLOCK). You can use these tags to change the maximum distance at which the [pair-correlation function](https://en.wikipedia.org/wiki/Radial_distribution_function) is evaluated.

## **ex-04-pair-correlation**

We plot radial distributuin function from the simulations of [ex-01](./ex-01-Si-melting-090fs/) and [ex-02](./ex-02-Si-melting-180fs/) and [ex-03](./ex-02-Si-melting-195fs/). 


## Some Insights

### Nose-Hoover Thermostat

To Simulate Nose-Hoover thermostat in VASP the most critical parameter that we need to specify is `SMASS`. 
SMASS determines the coupling between the heat bath and the system. We can say that it determines the
period of oscillation of temperature. You may read the references to read more about this. I will mention 
here only a practical guide of how to determine appropriate value of this parameter. Although any positive 
finite value of `SMASS` will result in canonical ensemble but for practical use it should be carefully chosen.
```
!  SMASS    mass Parameter for nose dynamic, it has the dimension
!           of a Energy*time**2 = mass*length**2 and is supplied in
!           atomic mass unit* LAT_PARAM_A**2 (this makes it  easy to define
!           the parameter)
```

Nose mentioned in his [paper](https://doi.org/10.1063/1.447334) that `SMASS or Q` should be choosen such that 
$$Q=\frac{2gk_bT}{w_0^2}$$
where $g$ is no of degree of freedom and $w_0$ is charateristic phonon frequency of the system.

`SMASS>=0` along with `MDALGO=2` should be used in VASP for simulation NHT along. If we set `SMASS=0` then vasp automatically calculates `SMASS` such that the period of oscillation of temperature is `40 timesteps`. i.e.
$$T =40\times\mathrm{POTIM} \Rightarrow w_0 = \frac{2\pi}{T}=\frac{2\pi}{40\times\mathrm{POTIM}}$$
where $\mathrm{POTIM}$ is timestep for MD simulation in vasp. And this is obvious in the vasp source `main.f` 

```FORTRAN
IF (SMASS==0)  SMASS= &
 ((40*POTIM*1E-15/TWOPI/LATT_PARAM_A)**2)* &
 2E20*K_EV*EVTOJ*KGTOAMU*NDEGREES_OF_FREEDOM*MAX(TEBEG,TEEND)
```

So ideally temperature fluctuation frequency should be of the same order as that of phonon frequency of the crystal. When we have in our hand phonon frequency we can calulate the period of oscillation and then we can use the same `SMASS` formula as given below 

```python
w0 = some_number
T = TWO_PI/w0 # In Femto Second, convert w0 to appropriate unit accordingly
SMASS = ((T*POTIM*1e-15/TWOPI/LATT_PARAM_A)**2)* 2.0e20*K_Jul*KGTOAMU*NDEGREES_OF_FREEDOM*MAX(TEBEG,TEEND)
```

To make life easier `calc-nose-mass.py` script is provided in the `bin` directory. Documentation is available. 


#### References
* http://staff.ustc.edu.cn/~zqj/posts/NVT-MD/
* https://doi.org/10.1063/1.447334
* https://www.vasp.at/wiki/index.php/SMASS

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

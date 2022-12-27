# **Ab Initio MD**

*You should read vasp-info.docx it is really good guide.*

In [MD](https://en.wikipedia.org/wiki/Molecular_dynamics) simulations, the motion of atoms (or molecules) at a specific temperature is simulated by means of the [classical equation of motion](https://en.wikipedia.org/wiki/Lagrangian_mechanics). In other words, each iteration simulates a time step, where atoms are treated as classical particles subject to forces as in [Newton's second law](https://en.wikipedia.org/wiki/Newton%27s_laws_of_motion). When these forces are computed quantum mechanically using *ab-initio* methods, one speaks of *ab-initio* MD. To employ the [canonical ensemble](https://en.wikipedia.org/wiki/Canonical_ensemble), or [NVT ensemble](https://en.wikipedia.org/wiki/Canonical_ensemble), the calculation must be done at constant number of particles (N), constant volume (V) and constant temperature (T).

To include the effect of temperature, some kind of [thermostat](https://www.vasp.at/wiki/index.php/Category:Thermostats) needs to be included. Methods to achieve that involve modifying the equations of motion either by introducing stochastic or deterministic terms through additional dynamical variables, which mimic the action of a heat bath in a real thermostat. The [Nosé-Hoover thermostat](https://www.vasp.at/wiki/index.php/Nose-Hoover_thermostat) corresponds to the latter. A possible deficiency of the [Nosé-Hoover thermostat](https://www.vasp.at/wiki/index.php/Nose-Hoover_thermostat) is the lack of [ergodicity](https://en.wikipedia.org/wiki/Ergodicity) in small or stiff systems, for instance in the [simulation of a single butane molecule](https://doi.org/10.1021/jp013689i), but it is perfectly suitable for the present example. 

In order to learn more about [MD algorithms in VASP](https://www.vasp.at/wiki/index.php/MDALGO) and how the effect of temperature is included by means of the [Nosé-Hoover thermostat](https://www.vasp.at/wiki/index.php/Nose-Hoover_thermostat) in this calculation, read the linked [VASP Wiki](https://www.vasp.at/wiki/index.php) articles.

## Understanding OSZICAR file
This is taken from https://uregina.ca/~eastalla/vaspinfo.docx.
```
reading files

WARNING: wrap around errors must be expected

entering main loop

N E dE d eps ncg rms rms(c)

RMM: 1 -.13238703E+04 -.132E+04 -.934E+02 56 .28E+02

RMM: 7 -.13401516E+04 -.267E-02 -.250E-02 68 .47E-01 .37E-02

RMM: 8 -.13401522E+04 -.567E-03 -.489E-03 53 .15E-01 .90E-03

1 T= 305. E= 0.48418874E+02 F= 0.46447673E+02 E0= 0.46517274E+02 EK= 0.19712E+01 SP= 0.00E+00 SK= 0.98E-05

```
This is from a molecular dynamics run. The middle lines are electron convergence lines. The last line is an energy summary for that nuclear geometry step:

T is the temperature (Kelvin)

E is the total energy of the extended system (F+EK+SP+SK).

F is a “partly” free energy for the system (E0 if insulators)

E0 is the ground-state potential energy for nuclei $(F – TS_{elec}): E0 = E_{elec}(\sigma\to0) + V_{nuc}$

EK is the kinetic energy of nuclei: E0 + EK would be internal energy U(T) for insulators

SP is the potential energy of the Nose heat bath

SK is the kinetic energy of the Nose heat bath

* The Nosé thermostat adds an extra degree of freedom to ion motion (now 3N+1). This is called the extended system. An NVT (canonical) ensemble for the real system is equivalent to, and performed as, an NVE (microcanonical) ensemble for the extended system.

* If E drifts too much (maybe more than 2 eV/1000 steps), reduce the timestep.

* F and E contains some electronic entropy (due to a smearing parameter σ used to aid in integration); hence the VASP manual calls them “free” energies. However, they do not contain nuclear-motion entropy, so don’t confuse F with Gibbs or Helmholtz energies.


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
* https://uregina.ca/~eastalla/vaspinfo.docx
* https://uregina.ca/~eastalla/

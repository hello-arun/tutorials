# Tutorial-for-kids

## Some comparisions

### Monkhorst-Pack Scheme

1. Quantum Espresso => The generated grid is always gamma centered.
2. VASP => The odd grid is gamma centered while even grid is not.

## Commonly used conversion factors

Conversion factors are obtained from http://greif.geo.berkeley.edu/~driver/conversions.html.
```text
Unit Conversions
Pressure:
1 eV/Angstrom3 = 160.21766208 GPa
1 Ha/Bohr3 = 29421.02648438959 GPa
1 GPa = 10 kbar = 145037.738007218 pound/square inch
1 Gbar = 100,000 GPa
1 Mbar = 100 GPa
1 kbar = 0.1 GPa
1 atm = 1.01325 bar = 0.000101325 GPa
1 pascal = 1.0E-09 GPa
1 TPa = 1000 GPa = 10 Mbar

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

Chemical Accuracy:
1 Kcal/mole = 43.36 meV
1 milli-Hartree (0.001) convergence = 27 milli-eV convergence
1.5 milli-Hartree (0.0015) convergence = chemical accuracy

quantity
1 mol = 6.02214179x10^23

IA64 Computer memory
1 MegaWord = 8 MegaBytes


Volumes
Simple Cubic volume a^3
FCC volume = a^3/4
BCC volume = a^3/2
HCP volume = (Sqrt[3]/2)*(a^2)*c
BC8 volume = a^3/2
```

# **ex-01-Si-melting-090fs**

*Perform an ab-initio MD simulation for cubic-diamond Silicon for 90fs with 64 atoms in a canonical ensemble using the Nosé-Hoover thermostat at 2000K.*

## **INPUTS**

See [POSCAR](https://www.vasp.at/wiki/index.php/POSCAR). Here 2x2x2 supercell with 64 atoms is used.

**Why Supercell?**
<details>
<summary> Click to see the answer!</summary>

The size of the supercell imposes a limit on the maximum wavelength of lattice vibrations. The supercell used in an MD simulation should be large enough to account for all vibration modes with significant contribution to the specific quantity of interest to be computed in MD. This can be estimated, e.g., from an appropriate phonon calculation, or from a series of MD simulations with different supercell sizes. 

Furthermore, in calculations considering for instance an absorbate-substrate problem, or simulations of gases and liquids, the size of the unit cell should be large enough to remove unphysical interactions between atoms and their periodic images. Note that, the same holds also for relaxations of such systems. 

In summary, for your MD simulation, you should choose a supercell large enough to ensure an [ergodic simulation](https://en.wikipedia.org/wiki/Ergodicity) and capture all long-wavelength vibrations of your system.
</details>

Check the tags set in the [INCAR](https://www.vasp.at/wiki/index.php/INCAR) file!

[IBRION](https://www.vasp.at/wiki/index.php/IBRION) = 0 switches on MD. Then, [NSW](https://www.vasp.at/wiki/index.php/NSW) and [POTIM](https://www.vasp.at/wiki/index.php/POTIM) set the number of ionic updates and the step size. For MD, the step size is a unit of time given in fs. 

[MDALGO](https://www.vasp.at/wiki/index.php/MDALGO) sets the thermostat. We use the [Nosé-Hoover thermostat](https://www.vasp.at/wiki/index.php/Nose-Hoover_thermostat), where the flow of energy between the physical system and the heat reservoir is regulated by the thermal inertia, or Nosé mass, [SMASS](https://www.vasp.at/wiki/index.php/SMASS). To realize an [NVT ensemble](https://en.wikipedia.org/wiki/Canonical_ensemble), the temperature at the beginning and at the end, i.e., [TEBEG](https://www.vasp.at/wiki/index.php/TEBEG) and [TEEND](https://www.vasp.at/wiki/index.php/TEEND), are equal and the volume is kept fixed with [ISIF](https://www.vasp.at/wiki/index.php/ISIF) = 2.

The [KPOINTS](https://www.vasp.at/wiki/index.php/KPOINTS) file specifies a single $\vec{k}$ point: The so-called 𝝘 point at $\vec{k}=(0,0,0)$. This is enough, because you are using a large supercell.

## **Calculation**

This calculation is done using `vasp_gam`, which got its name from the fact that it can *only* perform calculations at the 𝝘 point. Underneath that implies that the KS orbitals can be considered to be real valued. That means if you run the same calculation with `vasp_gam` and `vasp_std`, `vasp_gam` is faster.

Let us have a closer look at the standard output (stdout), that is printed to the terminal during the calculation. Note that every run is different because it starts from a different random seed.

## **Output**

<details>
<summary> Click to see the stdout! </summary>

```
 running on    2 total cores
 distrk:  each k-point on    2 cores,    1 groups
 distr:  one band on    1 cores,    2 groups
 vasp.6.3.0 16May21 (build Oct 27 2021 15:52:58) gamma-only                     
  
 POSCAR found type information on POSCAR Si
 POSCAR found :  1 types and      64 ions
 Reading from existing POTCAR
 scaLAPACK will be used
 Reading from existing POTCAR
 LDA part: xc-table for Pade appr. of Perdew
 POSCAR, INCAR and KPOINTS ok, starting setup
 FFT: planning ...
 WAVECAR not read
 prediction of wavefunctions initialized - no I/O
 entering main loop
       N       E                     dE             d eps       ncg     rms          rms(c)
RMM:   1     0.155222068701E+04    0.15522E+04   -0.44526E+04   162   0.508E+02
RMM:   2     0.297589951477E+03   -0.12546E+04   -0.12725E+04   162   0.145E+02
RMM:   3    -0.664488972878E+02   -0.36404E+03   -0.43415E+03   162   0.787E+01
RMM:   4    -0.220663864053E+03   -0.15421E+03   -0.16002E+03   162   0.560E+01
RMM:   5    -0.287411476155E+03   -0.66748E+02   -0.65206E+02   162   0.316E+01
RMM:   6    -0.320343488885E+03   -0.32932E+02   -0.28274E+02   162   0.212E+01
RMM:   7    -0.334632556790E+03   -0.14289E+02   -0.12331E+02   162   0.124E+01
RMM:   8    -0.340563651457E+03   -0.59311E+01   -0.53511E+01   162   0.792E+00
RMM:   9    -0.344491928264E+03   -0.39283E+01   -0.38231E+01   349   0.472E+00
RMM:  10    -0.344908101129E+03   -0.41617E+00   -0.41412E+00   352   0.165E+00
RMM:  11    -0.344951509187E+03   -0.43408E-01   -0.32463E-01   344   0.581E-01
RMM:  12    -0.344962136179E+03   -0.10627E-01   -0.10202E-01   336   0.281E-01    0.358E+01
RMM:  13    -0.340710112381E+03    0.42520E+01   -0.23514E+00   417   0.230E+00    0.221E+01
RMM:  14    -0.338768179258E+03    0.19419E+01   -0.54002E+00   463   0.369E+00    0.108E+00
RMM:  15    -0.338786847044E+03   -0.18668E-01   -0.10702E-01   324   0.600E-01    0.444E-01
RMM:  16    -0.338800009272E+03   -0.13162E-01   -0.16991E-02   327   0.294E-01    0.381E-01
RMM:  17    -0.338801421308E+03   -0.14120E-02   -0.26217E-03   321   0.108E-01    0.696E-02
RMM:  18    -0.338801478964E+03   -0.57656E-04   -0.60546E-04   262   0.494E-02
    1 T=  2000. E= -.32251463E+03 F= -.33880148E+03 E0= -.33880148E+03  EK= 0.16287E+02 SP= 0.00E+00 SK= 0.00E+00
 bond charge predicted
       N       E                     dE             d eps       ncg     rms          rms(c)
RMM:   1    -0.337852804095E+03    0.94862E+00   -0.22457E+01   324   0.780E+00    0.189E+00
RMM:   2    -0.338087873331E+03   -0.23507E+00   -0.24923E+00   325   0.306E+00    0.108E+00
RMM:   3    -0.338132790582E+03   -0.44917E-01   -0.50218E-01   340   0.124E+00    0.110E+00
RMM:   4    -0.338121036810E+03    0.11754E-01   -0.79021E-02   324   0.547E-01    0.579E-01
RMM:   5    -0.338129671306E+03   -0.86345E-02   -0.76437E-02   324   0.388E-01    0.314E-01
RMM:   6    -0.338123062866E+03    0.66084E-02   -0.16448E-02   326   0.207E-01    0.114E-01
RMM:   7    -0.338122886896E+03    0.17597E-03   -0.90935E-03   323   0.119E-01    0.334E-02
RMM:   8    -0.338122942074E+03   -0.55178E-04   -0.10506E-03   316   0.619E-02    0.244E-02
RMM:   9    -0.338122995490E+03   -0.53416E-04   -0.72833E-04   288   0.348E-02
    2 T=  1916. E= -.32252355E+03 F= -.33812300E+03 E0= -.33812299E+03  EK= 0.15599E+02 SP= -.49E-06 SK= 0.61E-12
 bond charge predicted
 prediction of wavefunctions
       N       E                     dE             d eps       ncg     rms          rms(c)
RMM:   1    -0.336180152440E+03    0.19428E+01   -0.58207E-01   324   0.139E+00    0.654E-01
RMM:   2    -0.336188071907E+03   -0.79195E-02   -0.84588E-02   339   0.505E-01    0.141E-01
RMM:   3    -0.336189675117E+03   -0.16032E-02   -0.16716E-02   353   0.208E-01    0.133E-01
RMM:   4    -0.336189894771E+03   -0.21965E-03   -0.26384E-03   332   0.918E-02    0.929E-02
RMM:   5    -0.336189974660E+03   -0.79889E-04   -0.63462E-04   285   0.448E-02
    3 T=  1685. E= -.32249392E+03 F= -.33618997E+03 E0= -.33618915E+03  EK= 0.13725E+02 SP= -.32E-01 SK= 0.27E-02
 bond charge predicted
 prediction of wavefunctions
       N       E                     dE             d eps       ncg     rms          rms(c)
RMM:   1    -0.333466462434E+03    0.27234E+01   -0.11737E+00   324   0.186E+00    0.677E-01
RMM:   2    -0.333487410180E+03   -0.20948E-01   -0.21196E-01   349   0.731E-01    0.231E-01
RMM:   3    -0.333490239144E+03   -0.28290E-02   -0.30702E-02   343   0.293E-01    0.176E-01
RMM:   4    -0.333490732641E+03   -0.49350E-03   -0.60607E-03   341   0.135E-01    0.933E-02
RMM:   5    -0.333490872875E+03   -0.14023E-03   -0.13599E-03   307   0.636E-02    0.379E-02
RMM:   6    -0.333490903027E+03   -0.30152E-04   -0.32459E-04   233   0.298E-02
    4 T=  1373. E= -.32245824E+03 F= -.33349090E+03 E0= -.33348022E+03  EK= 0.11179E+02 SP= -.18E+00 SK= 0.37E-01
    ...
    ...
    ...
   28 T=  2564. E= -.32254692E+03 F= -.30541712E+03 E0= -.30535338E+03  EK= 0.20878E+02 SP= -.38E+02 SK= 0.13E+00
 bond charge predicted
 prediction of wavefunctions
       N       E                     dE             d eps       ncg     rms          rms(c)
RMM:   1    -0.304962686456E+03    0.45437E+00   -0.50291E-01   338   0.931E-01    0.244E-01
RMM:   2    -0.304975571260E+03   -0.12885E-01   -0.13325E-01   371   0.442E-01    0.982E-02
RMM:   3    -0.304977016808E+03   -0.14455E-02   -0.15036E-02   370   0.179E-01    0.880E-02
RMM:   4    -0.304977314818E+03   -0.29801E-03   -0.32635E-03   345   0.764E-02    0.645E-02
RMM:   5    -0.304977364930E+03   -0.50112E-04   -0.63532E-04   268   0.359E-02
   29 T=  2426. E= -.32253591E+03 F= -.30497736E+03 E0= -.30491565E+03  EK= 0.19755E+02 SP= -.38E+02 SK= 0.28E+00
 bond charge predicted
 prediction of wavefunctions
       N       E                     dE             d eps       ncg     rms          rms(c)
RMM:   1    -0.304475187728E+03    0.50213E+00   -0.47067E-01   340   0.882E-01    0.228E-01
RMM:   2    -0.304487073861E+03   -0.11886E-01   -0.12380E-01   370   0.429E-01    0.918E-02
RMM:   3    -0.304488454010E+03   -0.13801E-02   -0.14617E-02   368   0.176E-01    0.790E-02
RMM:   4    -0.304488726979E+03   -0.27297E-03   -0.30125E-03   343   0.756E-02    0.581E-02
RMM:   5    -0.304488773682E+03   -0.46703E-04   -0.56686E-04   269   0.352E-02
   30 T=  2262. E= -.32252795E+03 F= -.30448877E+03 E0= -.30442641E+03  EK= 0.18424E+02 SP= -.37E+02 SK= 0.41E+00
Information: wavefunction orthogonal band  154  0.8863
 bond charge predicted
 prediction of wavefunctions
 wavefunctions rotated
 writing wavefunctions
```

</details>

After each electronic relaxation, the final line summarizes:  

| tag | meaning |
| --- | --- | 
| `T` | The instantaneous temperature. |
| `E` | The total energy `E` including the potential energy `F` of the ionic degree of freedom, the potential energy `SP` and kinetic energy `SK` of the Nose Hoover thermostat, and the kinetic energy of the ionic motion `EK`. It is  called `ETOTAL` in the [OUTCAR](https://www.vasp.at/wiki/index.php/OUTCAR) file. |
| `F` | The total free energy of the DFT calculation considering the artificial electronic temperature introduced by the smearing factor SIGMA. In fact, from the view point of MD, this is the potential energy of the ionic degree of freedom. It is  called `TOTEN` in the [OUTCAR](https://www.vasp.at/wiki/index.php/OUTCAR) file. |
| `E0` | The total energy of the DFT calculation obtained by subtracting the entropy term and letting SIGMA go to zero for the DFT total free energy `F`.  |
| `EK` | The kinetic energy of the ionic motion, called `EKIN` in the [OUTCAR](https://www.vasp.at/wiki/index.php/OUTCAR) file..  |
| `SP` | The potential energy of the [Nosé-Hoover thermostat](https://www.vasp.at/wiki/index.php/Nose-Hoover_thermostat), called `ES` in the [OUTCAR](https://www.vasp.at/wiki/index.php/OUTCAR) file. |
| `SK` | The kinetic energy of the [Nosé-Hoover thermostat](https://www.vasp.at/wiki/index.php/Nose-Hoover_thermostat), called `EPS` in the [OUTCAR](https://www.vasp.at/wiki/index.php/OUTCAR) file. |

**Why is the temperature not constant in every step?**

<details>
<summary> Click to see the answer!</summary>

That is the instantaneous temperature and not the observable ensemble average. Note that the idea of a constant temperature calculation is not that the instantaneous temperature is constant in every time step, but that the observable temperature, i.e., the ensemble average of the temperature is constant. You can find the value of the `mean temperature <T/S>/<1/S>` in the [OUTCAR](https://www.vasp.at/wiki/index.php/OUTCAR) file. In the thermodynamic limit, for sufficiently large number of atoms the fluctuations of the instantaneous temperature would also vanish.

</details>

## **Questions**

1. Are trajectories in ab-initio molecular dynamics the paths of quantum mechanical particles?
2. What is the standard format to store crystal structure information?
3. For what calculations can you use `vasp_gam`?
4. Is the total energy in an NVT ensemble conserved? 
5. Why do you use large supercells in simulations of molecular dynamics?
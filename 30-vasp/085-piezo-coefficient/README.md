We calculate here e_ij component of piezoelectric coefficient. e_ij corelates the polarization induced along "i"-direction in reponse strain applied along "j"-directoin.

* e_11 => Polarization along x-axis, Strain along x-axis, 
* e_21 => Polarization along y-axis, Strain along x-axis, 
* e_31 => Polarization along z-axis, Strain along x-axis, 

* e_12 => Polarization along x-axis, Strain along y-axis, 

Berry Phase approach is used to calculate the polarization generally. But For calculating polarization along the non-periodic direction (z-axis) we do not need berry
phase approach as polarization can be uniquely defined by placing the slab in the middle along the z-direction and taking 0,0,0 as the reference. So the case of out
of plane polarization is presented in ex-020-NbN.


## Rerference

* Giant piezoelectricity of monolayer group IV monochalcogenides: SnSe, SnS, GeSe, and GeS. Appl. Phys. Lett. 107, 173104 (2015); https://doi.org/10.1063/1.4934750
* https://chengcheng-xiao.github.io/post/2019/08/05/Berryphase_Ferroelectricity.html
* https://chengcheng-xiao.github.io

## ex-01-2SeSn-1
### Manual Method
|$e_{11}$|$e_{12}$|$e_{22}$|
|:--:|:--:|:--:|
|![](./ex-01-2SeSn-1/advancedManualStrainMethod/calc/piezo/strainX/fig-polXVsStrainX.svg)|![](./ex-01-2SeSn-1/advancedManualStrainMethod/calc/piezo/strainY/fig-polXVsStrainY.svg)|![](./ex-01-2SeSn-1/advancedManualStrainMethod/calc/piezo/strainY/fig-polYVsStrainY.svg)|

### DFPT Method

```
-------INCAR----------
IBRION  = 7 
LEPSILON = True
----------------------
Total Contr ((10^{-10}C/m))
------  ------  ------  ------  ------  ------
32.017   6.987   0.053   0.036  -0.000   0.001
-0.039  -0.055   0.010  31.326  -0.000  -0.000
 0.000   0.000  -0.000   0.000   0.002   0.015
------  ------  ------  ------  ------  ------
```
## ex-02-2B2O3-1
### Manual Method

|$e_{21}$|$e_{22}$|
|:--:|:--:|
|![](./ex-02-2B2O3-1/manualStrainMethod/calc/piezo/e21/fig-polVsStrain.svg)|![](./ex-02-2B2O3-1/manualStrainMethod/calc/piezo/e22/fig-polVsStrain.svg)|

### DFPT Method
```
-------INCAR----------
IBRION  = 7 
LEPSILON = True
----------------------
Total Contr ((10^{-10}C/m))
------  ------  ------  ------  ------  ------
-0.003  -0.003  -0.000   0.006  -0.000   0.000
-0.178  -0.756  -0.025  -0.001   0.000   0.000
 0.000   0.000   0.000  -0.000   0.066  -0.000
------  ------  ------  ------  ------  ------
```

##  ex-03-6PbS-1
### Manual
|$e_{21}$|$e_{22}$|
|:--:|:--:|
|![](./ex-03-6PbS-1/manualStrainMethod/calc/piezo/e21/fig-polVsStrain.svg)|![](./ex-03-6PbS-1/manualStrainMethod/calc/piezo/e22/fig-polVsStrain.svg)|

### DFPT
```
Total Contr ((10^{-10}C/m))
------  ------  ------  ------  ------  ------
-0.013  -0.006   0.006  51.750   0.003  -0.003
14.646  35.102   0.105  -0.000   0.001   0.001
-0.001  -0.001  -0.001  -0.000  -0.019  -0.002
------  ------  ------  ------  ------  ------
```
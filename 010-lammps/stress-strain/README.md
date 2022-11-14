# Stress-Strain

We will explain how Stress-Strain curve can be calculated in lammps. In LAMMPS stress is described in six component 
$\sigma_{xx},\sigma_{yy},\sigma_{zz},\sigma_{xy},\sigma_{xz},\sigma_{yz}$ 
and can be accessed by index 1 to 6. Nine component stress tensor is also available but we rearely use that.

1. Calculate $\sum_{all\ atoms}$ Stress/atom 
2. Caculate the average for sufficient time(250 fs)
3. Devide by correct volume
4. Output
5. Common mistakes

## Calculate $\sum_{all\ atoms}$ Stress/atom 

The following command will give as six component stress tensor per each atom. The problem here is that this stress-tensor is in pressure*volume units. It would need to be divided by a per-atom volume to have units of stress (pressure). Per-atom volume is hard to compute so we will find a way out later.

```
# compute per-atom stress
compute 1 all stress/atom NULL
# sum it up for all atoms
compute 2 all reduce sum c_1[1] c_1[2] c_1[3] c_1[4] c_1[5] c_1[6]

```

## Calculate average

```
fix avg_stress all ave/time 1 1000 1000 c_2[1] c_2[2] c_2[3] c_2[4] c_2[5] c_2[6]
```

## Divide by volume of all atoms

After that we need to divide by total volume of all atoms. This volume is different than total volume of simulation box. For a 2D sheet(ex. Graphene) we need to consider finite thickness to calculate volume of atoms. This thickness is generally van-der wall radius. So a convinient method could be( for 2D sysmtems).

```math
\begin{align*}
V & = \mathrm{Volume\ of\ sim\ box} \\
V_{real} & = \mathrm{Volume\ of\ all\ atoms}  \\
L_z & = \mathrm{Sim\ box\ size\ along\ non\ periodic\ dim} \\
T & = \mathrm{Thickness\ of\ monolayer} \\
\mathrm{Then...} \\
V_{real} & = \frac{V*T}{L_z}
\end{align*} 
```

```LAMMPS
variable Lx equal lx
variable Ly equal ly
variable Lz equal lz
variable Vol equal vol
variable thickness equal 6.100  # Thickness of monolayer
fix avg_dim  all ave/time 1 1000 1000 v_Lx v_Ly v_Lz v_Vol
variable realVol equal f_avg_dim[4]*v_thickness/(f_avg_dim[3]) # real volume of all atoms        
variable sigma vector f_avg_stress/v_realVol
```

## Output

Different component of stress tensor can be printed as follows.

```
fix log all print 1000 "&
$(v_sigma[1]:%0.3f),$(v_sigma[2]:%0.3f),$(v_sigma[3]:%0.3f),&
$(v_sigma[4]:%0.3f),$(v_sigma[5]:%0.3f),$(v_sigma[6]:%0.3f),&
title "sigma_xx,sigma_yy,sigma_zz,&
sigma_xy,sigma_xz,sigma_yz" &
append ./log-stress-strain.csv screen no
```

## Common mistakes

* In case of nano flakes when finite vaccuum is present along all dimension then the above mentioned method will not work. Carefully calculate the total volume of atoms here.

* In such cases it is more suitable to use sss periodic boundary condition and then the above mentioned method will work.

* In case of bending of monolayer you will also need to calculate total atoms voulume carefully.

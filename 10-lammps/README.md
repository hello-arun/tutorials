# LAMMPS Tutorials

Various tutorials for LAMMPS. This repo contains short tricks that we generally need to incorporate in bigger projects.

## How to use msi2lmp

Sometimes we need to move Material Studio Simulations to lammps. We can do it by exporting material studio file in .car and .mdf format and then use msi2lmp tools to convert those files to lammps format. msi2lmp tool is shipped with lammps and it is compiled by default when we compile lammps. To use this set we need a parameter set .frc file that we can either use that is shipped with lammps or from outside source. Before exporting the material studio file we must be sure that the atom type and bonds are all defined perfectly along with the charge. For example when we want to use pcff force field then the force field type and charge must be set before exporting the files to .car format. This can be done without runnning any calculation. we just need to open the forcite job submission tool and then if we click around on more options a few times we can find the option to calculate charge as per force field and assign atom types correctly. 

A very nice referecen to get external frc file is https://bionanostructures.com/interface-md/ which ships interface force field of metal and organic materils worth visiting.


## Some Hacks

### -skiprun

Insert the command `timer timeout 0 every 1` at the beginning of an input file or after a clear command. This has the effect that the entire LAMMPS input script is processed without executing actual run or minimize and similar commands (their main loops are skipped). This can be helpful and convenient to test input scripts of long running calculations for correctness to avoid having them crash after a long time due to a typo or syntax error in the middle or at the end.

## Worth visiting
* http://gebi.df.uba.ar/support/
* https://bionanostructures.com/interface-md/

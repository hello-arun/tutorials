# LAMMPS Tutorials

Various tutorials for LAMMPS. This repo contains short tricks that we generally need to incorporate in bigger projects.


## Some Hacks

### -skiprun

Insert the command `timer timeout 0 every 1` at the beginning of an input file or after a clear command. This has the effect that the entire LAMMPS input script is processed without executing actual run or minimize and similar commands (their main loops are skipped). This can be helpful and convenient to test input scripts of long running calculations for correctness to avoid having them crash after a long time due to a typo or syntax error in the middle or at the end.

## Worth visiting
* http://gebi.df.uba.ar/support/

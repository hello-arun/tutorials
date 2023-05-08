## Check List

* Check INCAR-relax.pw and INCAR-nscf.pw has same unit-cell and atomic configuration when starting.
* Atomic cordinates must be crystal unit
* Set the direction of strain in runSetup.sh
* Set the direction of polarization calculation in INCAR-nscf.pw
* Please note that only atomic coordinates provided in nscf file are overwritten from that of previous scf-run. The unit-cell remains the same as provided in the nscf file.
So do not forget to modify both scf and nscf file accordingly.

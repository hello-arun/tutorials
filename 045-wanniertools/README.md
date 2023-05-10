## Refs
* http://www.wannier.org/support/
* https://indico.ictp.it/event/8301/other-view?view=ictptimetable
* https://www.wanniertools.org/tutorials/high-quality-wfs/
* https://docs.epw-code.org/doc/School2021.html#

* *Note that, unless you specify wf_collect=.true. in your pw.x input
file, you must run pw2wannier90 with the same number of processors as pw.x*
## seedname.win

Format and meaning of different parameters in the file `seedname.win`.

```bash
num_wann = X # No of WF fnction to be found
num_iter = X # Interation to minm. procedure; if num_iter=0 => generate projected WFs 
             # rather than maximally localized ones; Default 100

# This part is for initial guess of unitary transformations
begin projections

end projections
   
```

## kmesh.pl script

***Taken from user_guide.pdf***


The wannier90 code requires the definition of a full Monkhorst–Pack grid of k points. In the input
file the size of this mesh is given by means of the mp_grid variable. E.g., setting
```
mp_grid = 4 4 4
```
tells wannier90 that we want to use a `4 × 4 × 4` k grid.
One has then to specify (inside the kpoints block in the the seedname.win file) the list of k points of
the grid. Here, the `kmesh.pl` Perl script becomes useful, being able to generate the required list.
The script can be be found in the utility directory of the wannier90 distribution. To use it, simply
type:
```
./kmesh.pl nx ny nz
```
where `nx`, `ny` and `nz` define the size of the Monkhorst–Pack grid that we want to use (for instance, in
the above example of the 4 × 4 × 4 k grid, nx=ny=nz=4).
This produces on output the list of k points in Quantum Espresso format, where (apart from a header)
the first three columns of each line are the k coordinates, and the fourth column is the weight of each
k point. This list can be used to create the input file for the ab-initio nscf calculation.
If one wants instead to generate the list of the k coordinates without the weight (in order to copy and
paste the output inside the seedname.win file), one simply has to provide a fourth argument on the
command line. For instance, for a `4×4×4` k grid, use
```
./kmesh.pl 4 4 4 wannier
```
and then copy the output inside the in the kpoints block in the seedname.win file
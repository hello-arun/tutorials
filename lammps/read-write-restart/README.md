# Restart LAMMPS run

We cover reading and writing LAMMPS run in this simulation.

## Reading a restart file

How to Read in a previously saved system configuration from a restart file?

While specifying names for reading restart file(s) we, can provide two wild characters.

### 1. "\*" 

```LAMMPS
read_restart save.*
read_restart save.*.mpiio
```
If a "\*" appears in the filename, the directory is searched for all filenames that match the pattern where "\*" is replaced with a timestep value. The file with the largest timestep value is read in. Thus, this effectively means, read the latest restart file. It’s useful if you want your script to continue a run from where it left off.

### 2. "%" 

```LAMMPS
read_restart save.% remap
read_restart save.*.% remap
```

If a “%” character appears in the restart filename, LAMMPS expects a set of multiple files to exist. Read_restart will first read a filename where “%” is replaced by “base”. This file tells LAMMPS how many processors created the set and how many files are in it. Read_restart then reads the additional files. For example, if the restart file was specified as save.% when it was written, then read_restart reads the files save.base, save.0, save.1, … save.P-1, where P is the number of processors that created the restart file.


## Example

Examples are added in [write-restart.lmp](./write-restart.lmp) and [read-restart.lmp](./read-restart.lmp)

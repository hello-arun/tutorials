# Parallelisation in Quantum Espresso 

*(Revision Needed)*

Parallelisation in massively parallel machines is necessary. And it can be simply achieeved in Quantum Espresso. 

## Level of Parallelisation

Quantum espresso provides various levels of parallelisation. But two most important parts are 
* K-Points
* Bands

### K-Points

K Point parallelisation is achieved by `npool`.

### Bands
    ­nb (­nband, ­nbgrp, ­nband_group) # of band groups
Band parallelisation is achieved by `-nb/ -nband/ -nbgrp/ -nband_group` etc.

## Example

Here is an example script. We can note here that we have total `8 nodes` each having `24 cpus`. We have devided 8 nodes in 4 batches `-npool 4`. Each batch have 2 nodes. further Each batch is devided in 2 sub-batches `-nbnd 2`
 for bands parallelisation.
 
```bash
#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name="__jobName"
#SBATCH --constraint=intel
#SBATCH --nodes=8
#SBATCH --ntasks-per-node=24
#SBATCH --time=2:30:00
#SBATCH --mail-type=ALL
#SBATCH --err=./std.err
#SBATCH --output=./std.out
##SBATCH --exclusive
module load quantumespresso/6.6
mpirun -np ${SLURM_NPROCS} pw.x -npool 4 -nb 2 -i INCAR.pw > OUTCAR.pw
```
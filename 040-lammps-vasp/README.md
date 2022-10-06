# LAMMPS-VASP interface

We interlink LAMMPS and VASP to do ab-initio simulation.

## Step 0 Create python2 environment

Create python2 env with the `environment.yml` given.
```
mamba env create -n lmp-vasp -f environment.yml --force
```

## Step 1 Build LAMMPS with its MESSAGE package installed

Script for installing LAMMPS with MESSAGE pack is available. Use it to setup lammps. You need active 

```bash
bash install-lammps-with-MESSAGE-pack.sh
```
## Step 2 Procedure

After completing step 1 and step 2. You can interlink vasp and lammps as provided in `001-test-Si`

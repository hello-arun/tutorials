# ase-tutorial

Most commonly used ASE integration with Quantum Espresso, VASP and LAMMPS packages.

## Conda environment

```bash
# To build
mamba env create --prefix ./env --file environment.yml --force

# To update the existing one
$ conda env update --prefix ./env --file environment.yml  --prune
```

## Building the Conda environment

After adding any necessary dependencies that should be downloaded via `conda` to the 
`environment.yml` file and any dependencies that should be downloaded via `pip` to the 
`requirements.txt` file you create the Conda environment in a sub-directory `./env`of your project 
directory by running the following commands.

```bash
mamba env create --prefix ./env --file environment.yml --force
```

### Updating the Conda environment

If you add (remove) dependencies to (from) the `environment.yml` file or the `requirements.txt` file 
after the environment has already been created, then you can re-create the environment with the 
following command.

```bash
$ conda env update --prefix ./env --file environment.yml  --prune
```


# Phonon modes using phonopy

## Setup Phonopy

`phonopy` is provided by conda-forge channel. You can install 
```
conda install -c conda-forge phonopy
```
or to install in a specific conda environment.
```
envName="basic"  # conda env name
conda install -n $envName -c conda-forge phonopy 
```

## How to run

```
bash run.sh  
# After all scf runs complete

cd ./calc
bash run-postprocess.sh > std-postporcess.out
```

## Refererences
* http://phonopy.github.io/phonopy/install.html
* https://rehnd.github.io/tutorials/vasp/phonons
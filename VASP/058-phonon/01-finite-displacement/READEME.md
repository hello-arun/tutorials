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

```bash
# cd example-dir
bash run.sh  
# After all scf runs complete

cd ./calc
bash run-postprocess.sh > std-postporcess.out
```

## Phonopy Quick Notes
* By default phonopy have phonon bands in THz frequency units.
* Set `FREQUENCY_CONVERSION_FACTOR = 521.3706217` in `conf-band.conf`to plot phonon bands in cm-1 unit.
    
    1THz = 33.356 cm-1 but setting `FREQUENCY_CONVERSION_FACTOR = 33.356` will not correctly convert to cm-1 unit because by default `FREQUENCY_CONVERSION_FACTOR` is used internally by phonopy to convert the data obtained from calculators(VASP, Quantum-Espresso) to THz unit. And these default values can be found on https://phonopy.github.io/phonopy/interfaces.html#frequency-default-value-interfaces. So you also need to account for that value, and for VASP that is 
    ```
    VASP      | 15.633302
    ```
    so
    $$15.633302\times33.356 = 521.3706217$$
    `ex-02-monolayer-MoTe2-2H` shows phonon bands in cm-1 units.

* Use larger cells to compute correct phonon bands, smaller cell can not capture those correctly.
* See example-02 to see the difference between 1x1 cell and 4x4 cell phonon bands.

## Refererences
* http://phonopy.github.io/phonopy/install.html
* https://rehnd.github.io/tutorials/vasp/phonons
# Example-02

We calculate Polarization change as a function of strain in h-BN. This is already performed in [J. Phys. Chem. Lett. 2012, 3, 19, 2871–2876](https://doi.org/10.1021/jz3012436).

## Procedure

```bash
cd ./example-02
bash ./run.sh
## Now wait for all the calculations to finish. After that
cd ./calc
bash grep-polarization.sh
python plot-polarization.py
```
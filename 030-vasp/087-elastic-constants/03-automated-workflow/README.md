## For the impatient

You need to copy the `POSCAR`, `POTCAR`, `KPOINTS` inside `./data` directory. You need to modify `VPKIT.in` and `run.sbatch` based upon how you want to submit each job(like cores and nodes). After that you just need to run this command

***Node you may also need to modify `vaspkit="~/application/vaspkit/1.4.0/vaspkit.1.4.0/bin/vaspkit"` this line from `./run.sh` if vaspkit is installed at different system path***

```
# cd to /automated-workflow
bash run.sh
# The log of this command will be inside calc/strain-method/
```
## GPa to N/m

For *2D materials* the values of elastic constant can be converted to N/m unit by multiplying these values by lattice parameter along out of plane direction. The unit of lattice params should be in *nanometer*. such as

```text
say
    C11 = 10GPA
    lattice parameter(C)=20 Angstrom
then
    C11 = 10*2 = 20N/m
```


## What does it automate

For vaspkit these are the steps that we need to follow. This script will automate upto 4th step. After all the calculations are over
you need to run a post processing step to get the elastic constants printed.


1. Generate INCAR KPOINTS POTCAR and VPKIT.in Files.
2. Then run vaspkit in the same folder with taskid 200. It will create some folders with strained poscars.
```bash
vaspkit -task 200
```
3. Then batch run the VASP cmd in all these folders to obtain OUTCAR.
4. Then modify the first line in VPKIT.in file to 2:(post process)
5. Again run the vaspkit with taskid 200. It will display all the elastic constants in the ouput.
```bash
vaspkit -task 200
```
## boilerplate

You can download this boilerplate via 

```bash
# Check What will be downloaded
svn ls https://github.com/hello-arun/Tutorial-for-kids.git/trunk/030-vasp/087-elastic-constants/03-automated-workflow
# Download the code
svn export https://github.com/hello-arun/Tutorial-for-kids.git/trunk/030-vasp/087-elastic-constants/03-automated-workflow
```

## Footnote
* vaspkit : ~/application/vaspkit/1.4.0/vaspkit.1.4.0/bin/vaspkit
## How to do 

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

```bash
# Check What will be downloaded
svn ls https://github.com/hello-arun/Tutorial-for-kids.git/trunk/030-vasp/087-elastic-constants/03-automated-workflow
# Download the code
svn export https://github.com/hello-arun/Tutorial-for-kids.git/trunk/030-vasp/087-elastic-constants/03-automated-workflow
```


## Footnote
* vaspkit : ~/application/vaspkit/1.4.0/vaspkit.1.4.0/bin/vaspkit
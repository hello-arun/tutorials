How to do 

1. Generate INCAR KPOINTS POTCAR and VPKIT.in Files.
2. Then run vaspkit in the same folder with taskid 200. It will create some folders with strained poscars.
3. Then batch run the VASP cmd in all these folders to obtain OUTCAR.
4. Then modify the first line in VPKIT.in file to 2:(post process)
5. Again run the vaspkit with taskid 200. It will display all the elastic constants in the ouput.
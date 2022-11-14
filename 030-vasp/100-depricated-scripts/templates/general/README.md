# VASP general template
This template is created by **_Arun Jangir_** on : *03-Oct-2021*


1.  `init` :   Put the POSCAR POTCAR CONTCAR OPTCELL KPOINTS in this dir.
2.  `src`  :   Project related script files will be put in this file
3.  `bin`  :   This folder contains script to launch vs-code server. always run these script from project directory ex.

        sbatch ./bin/launch-code-server.sbatch

    Do not worry about the `.srun` files these files are always called within from sbatch scripts.
    This folder can also contain any compiled files if required.

4.  `calc` :   this folder will have all the calculation files related with this project.
5.  `results` :  Obtained results will be copied to this dir.

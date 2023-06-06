This folder contains all the required files to do a NEB run.

| File | Discription |
| ---: | :--- |
| image-0.lmp     | initial configuration file|
| image-0.cord    | final cordinates of all the mobile atoms|
| INCAR.lmp       | lammps script instruction for NEB|
| energy-grep.sh  | bash script to extract final energy of each NEB intermediate image|
| plot-NEB.py     | python script to plot Minimum energy path vs reaction cord.|
| 0-gen-image | folder containing essential python script to generate image-0.lmp and image-1.cord file|

to generate image-0.lmp and image-0.cord file use 0-gen-image utility a
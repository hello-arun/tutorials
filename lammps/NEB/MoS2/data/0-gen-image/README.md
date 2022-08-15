copy image-0.lmp and image-1.cord from ./out* folder to data folder manually.

to use the gen-data-for-NEB.py command you need to first of all have a one to one mapping of atoms in the unit cell
this is the most crucial step. if you do not do it correctly the intermediate images generated will not be correct 
and give undesired results

| File | Discription |
| ---: | :--- |
| 1T-unit-cell.lmp | unit cell of 1T-MoS2|
| 2H-unit-cell.lmp | unit-cell of 2H-MoS2|

We do full relaxation of SnSe here. *c*-axis is kept fixed and cell is only allowed to relax along *a* and *b*-direction to simulate monolayer relaxation.

The vasp code used here is not original. This is an modified version of vasp in which implementaion of allowing certain dimension to be fixed while relaxation is added.
This is achieved by specifying the constrained dimension in the OPTCELL file. The three numbers in the OPTCELL file respectively represents x,y and z axis. 0 means fixed dimensiona and 1 means movealbe
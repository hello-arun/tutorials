from ase.io import vasp,lammpsdata
import os
vaspRelaxedContcar="/ibex/scratch/jangira/current-projects/crg-project-restart/05-DFT/1-MoTe2/2H-ortho/10-relax/calc/fullRelax/CONTCAR"
lmpOutPoscar="./POSCAR.lmp"
data=vasp.read_vasp(vaspRelaxedContcar)
lammpsdata.write_lammps_data(lmpOutPoscar, data,units="real",atom_style="charge")

with open(lmpOutPoscar,"r") as fd:
    lines=fd.readlines()
    lines[0]=vaspRelaxedContcar+os.linesep
with open(lmpOutPoscar,"w") as fd:
    fd.writelines(lines)

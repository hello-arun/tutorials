from ase.io import vasp
from ase import Atoms
atoms:Atoms = vasp.read_vasp("./POSCAR")
pos = atoms.get_positions()
pos[:,0]-=pos[-2,0]
pos[:,1]-=pos[-2,1]
atoms.set_positions(pos)
vasp.write_vasp("./POSCAR_REV",atoms,direct=True,wrap=True)
from ase.io import vasp
from ase import Atoms

# Reading POSCAR
data:Atoms = vasp.read_vasp("./data/POSCAR")
unit_cell = data.get_cell()
atomic_nums = data.get_atomic_numbers()
atomic_poss = data.get_scaled_positions()

print(unit_cell)
print(atomic_nums)
print(atomic_poss)

# Let's apply some strain on the cell
scaled_unit_cell = unit_cell.copy()

scaled_unit_cell[0,0]*=1.15
scaled_unit_cell[1,1]*=1.15
data.set_cell(scaled_unit_cell,scale_atoms=True)
vasp.write_vasp("./data/POSCAR-out",atoms=data,label="2H-MoS2",direct=True)



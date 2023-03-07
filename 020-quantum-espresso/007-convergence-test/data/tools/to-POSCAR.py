from ase.io import vasp,espresso
from ase import Atoms
data:Atoms = espresso.read_espresso_in("./INCAR-scf.pw")
vasp.write_vasp("./POSCAR", data)
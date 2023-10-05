#read structure from file
from pymatgen.io.vasp import Poscar
from pymatgen.core import Structure
from pymatgen.symmetry.analyzer import SpacegroupAnalyzer

struct = Structure.from_file("POSCAR")
sga = SpacegroupAnalyzer(struct,symprec=1e-8)
struct_prim_std = sga.get_primitive_standard_structure(international_monoclinic=False)
poscar = Poscar(struct_prim_std)
poscar.write_file("POSCAR-prim-std")

sga = SpacegroupAnalyzer(struct_prim_std,symprec=1e-8)
struct_conv_std = sga.get_conventional_standard_structure()
poscar = Poscar(struct_conv_std)
poscar.write_file("POSCAR-conv-std")
# #write primitive and conventional cells
# poscar = Poscar(struct_symm_conv)
# poscar.write_file(filename="POSCAR-conv",significant_figures=4)
# poscar = Poscar(struct_prim_std)
# poscar.write_file(filename="POSCAR-prim",significant_figures=4)
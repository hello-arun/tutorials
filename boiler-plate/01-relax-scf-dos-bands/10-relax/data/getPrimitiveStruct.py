# Read structure from file
from pymatgen.core import Structure,Site
from pymatgen.symmetry.analyzer import SpacegroupAnalyzer


def customSort(site:Site):
    return site.specie.Z

inputFile="POSCAR"
struct = Structure.from_file(inputFile)
sga = SpacegroupAnalyzer(struct)
struct_prim_std:Structure = sga.get_primitive_standard_structure(international_monoclinic=False)
struct_prim_std.sort(key=customSort)
struct_prim_std.to_file(f"{inputFile}-prim",fmt="poscar")

sga = SpacegroupAnalyzer(struct_prim_std)
struct_conv_std = sga.get_conventional_standard_structure()
struct_conv_std.sort(key=customSort)
struct_conv_std.to_file(f"{inputFile}-conv",fmt="poscar")


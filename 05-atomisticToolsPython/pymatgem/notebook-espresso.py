from pymatgen.io.pwscf import PWInput
from pymatgen.core import Structure
from pymatgen.symmetry.analyzer import SpacegroupAnalyzer
from pymatgen.io.ase import AseAtomsAdaptor
from ase.io import read
from ase.io.espresso import read_espresso_in,write_espresso_in
from pymatgen.io.vasp import Kpoints

struct = AseAtomsAdaptor.get_structure(read_espresso_in(file="INCAR-vc-relax.pw"))
# pwinput = Structure.from_file("INCAR-vc-relax.pw",fmt="pwscf")
# for site in struct:
#     print(site.frac_coords)

sga = SpacegroupAnalyzer(struct)
print("Crystal System:",sga.get_crystal_system())

primitiveStruct = sga.find_primitive()

# You can use ase to write pwscfInput but better choice is to use pymatgen
# with open("INCAR-primitve.pw","w") as fd:
#     primitiveAtoms = AseAtomsAdaptor.get_atoms(primitiveStruct)
#     write_espresso_in(fd, primitiveAtoms)

control = {
    "calculation"  :  "vc-relax",
    "forc_conv_thr" :  1.0e-04,
    "etot_conv_thr" :  1.0e-6,
    "nstep"         : 100,
    "pseudo_dir"    : "./",
    "outdir"        : "./wfc-out"    
}

system = {
    "ecutrho"     :  600,
    "ecutwfc"     :  70,
    "occupations" : "smearing",
    "smearing"    : "gaussian",
    "degauss"     : 0.01
}

electrons = {
    "conv_thr"         :  1.0e-10,
    "electron_maxstep" :  200,
    "mixing_beta"      :  7.00000e-01
}

ions = {
        "ion_dynamics" : "bfgs"
}

cell = {
    "cell_dynamics": "bfgs",
    "cell_dofree" : "all"
}

kpoints = Kpoints.automatic_density_by_lengths(primitiveStruct,length_densities= [50,50,50])
lengths = primitiveStruct.lattice.lengths
angles = primitiveStruct.lattice.angles
print(f"a:{lengths[0]:.3f}, b:{lengths[1]:.3f}, c:{lengths[2]:.3f}")
print(f"alpha:{angles[0]:.3f}, beta:{angles[1]:.3f}, gamma:{angles[2]:.3f}")
print(kpoints)
pwInput = PWInput(
    structure=primitiveStruct,
    pseudo={"Al":"Al.pz-n-rrkjus_psl.0.1.UPF","N":"N.pz-n-rrkjus_psl.0.1.UPF"},
    control=control,
    system=system,
    electrons=electrons,
    kpoints_mode="automatic",
    kpoints_grid=kpoints.kpts[0],
    ions = ions,
    cell = cell,
)

pwInput.write_file(filename="INCAR-primitive.pw")
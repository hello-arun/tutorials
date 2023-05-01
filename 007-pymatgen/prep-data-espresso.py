from ase import Atoms
from ase.io import read
from pymatgen.io.vasp import Kpoints
from pymatgen.core import Structure
from pymatgen.io.ase import AseAtomsAdaptor
from pymatgen.io.pwscf import PWInput

outcarFile="./OUTCAR-vc-relax.pw"

# This is convinient way to read espresso-outFile
aseAtoms:Atoms = read(outcarFile,format="espresso-out",index=-1)
relaxedStruct = AseAtomsAdaptor.get_structure(aseAtoms)

kpoints = Kpoints.automatic_density_by_lengths(relaxedStruct,length_densities= [45 for i in range(3)])
lengths = relaxedStruct.lattice.lengths
angles = relaxedStruct.lattice.angles
print(f"a:{lengths[0]:.3f}, b:{lengths[1]:.3f}, c:{lengths[2]:.3f}")
print(f"<bc:{angles[0]:.3f}, <ac:{angles[1]:.3f}, <ab:{angles[2]:.3f}")
print(kpoints)

control = {
    "calculation"  :  "--",
    "forc_conv_thr" :  1.0e-04,
    "etot_conv_thr" :  1.0e-6,
    "nstep"         : 100,
    "pseudo_dir"    : "./",
    "outdir"        : "./wfc-out"    
}

system = {
    "ecutrho"     :  600,
    "ecutwfc"     :  70,
    "occupations" : "--",
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

# Write scf
control["calculation"] = "scf"
system["occupations"] = "smearing"
pwSCF = PWInput(
    structure=relaxedStruct,
    pseudo={"Al":"Al.pz-n-rrkjus_psl.0.1.UPF","N":"N.pz-n-rrkjus_psl.0.1.UPF"},
    control=control,
    system=system,
    electrons=electrons,
    kpoints_mode="automatic",
    kpoints_grid=kpoints.kpts[0],
    # ions = ions,
    # cell = cell,
)
pwSCF.write_file(filename="INCAR-scf.pw")

# Write nscf
control["calculation"] = "nscf"
system["occupations"] = "tetrahedra"
pwNSCF = PWInput(
    structure=relaxedStruct,
    pseudo={"Al":"Al.pz-n-rrkjus_psl.0.1.UPF","N":"N.pz-n-rrkjus_psl.0.1.UPF"},
    control=control,
    system=system,
    electrons=electrons,
    kpoints_mode="automatic",
    kpoints_grid=kpoints.kpts[0],
    # ions = ions,
    # cell = cell,
)
pwNSCF.write_file(filename="INCAR-nscf.pw")



# This is not yet properly implemented in ase as of version 3.22.1
# with open("OUTCAR-vc-relax.pw","r") as fileObj:
#     config = read_espresso_out(fileObj,index=slice(-1,None))
#     print(config)
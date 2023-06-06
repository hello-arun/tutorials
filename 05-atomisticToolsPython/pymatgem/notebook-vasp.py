import numpy as np
import ase
import shutil
import os
from pymatgen.core import Structure
from pymatgen.symmetry.analyzer import spglib
from pymatgen.symmetry.bandstructure import HighSymmKpath
from pymatgen.io.vasp import Incar, Kpoints, Poscar
import subprocess

__pymat_version = (
    subprocess.run(
        ['pip show pymatgen | grep "Version"'],
        capture_output=True,
        text=True,
        shell=True,
    )
    .stdout.strip()
    .split(": ")[1]
)
__ase_version = ase.__version__
print("pymatgen version:", __pymat_version)
print("     ase version:", __ase_version)

assert __pymat_version == "2023.3.23" and __ase_version == "3.22.1"

# This script will prepare the input files needed to automate.
# This works for vasp here

# First of all we need a relaxed structure
relaxedPoscarFile = "/home/jangira/Documents/github/Tutorial-for-kids/007-pymatgen/030-vasp/POSCAR"
potcarFile = f"{os.path.dirname(relaxedPoscarFile)}/POTCAR"
systemName = "ABC"
filterKpoints=True # This things will filter the final KPOINTS use with caution

scfDIR = "11-scf/data"
dosDIR = "12-dos/data"
bandsDIR = "13-bands/data"

poscar = Poscar.from_file(
    relaxedPoscarFile, check_for_POTCAR=False, read_velocities=False
)
print(poscar.structure)

scfKpoints = Kpoints(
    comment="KPOINTS written by PYMATGEN",
    style="Monkhorst",
    kpts=[[16,16,1]],
    kpts_shift=(0.0,0,0)
    )
# Let us just quickly setup POTCAR and KPOINTS
for DIR in [scfDIR, dosDIR, bandsDIR]:
    os.makedirs(DIR, exist_ok=True)
    shutil.copy(potcarFile, DIR)

# For SCF

# We setup first INCAR File
baseIncarProps = {
    # System Setting
    "SYSTEM": systemName,
    "PREC": "Accurate",
    "GGA": "PE",    # PE=PBE, 91=Perdew-Wang-91
    "ENCUT": 600,

    # Type of Calculation
    "NSW": 0,       # Max Number of Ionic relaxation, for SCF set it to 0
    "IBRION": -1,   # -1=for scf, 0=MD, 2=cg algorithm to update position
    "ISPIN": 1,     # 1=spin unpol, 2=spin pol
    # "IVDW" : 12,  # D3 vdw correction
    # "ISYM":0,     # Symmetry Switched off

    # Continue or fresh
    "ISTART": 0,    # 0=Scratch, 1=Continuation Job only read wavecar file
    "ICHARG": 2,    # 2=ch den from sup pos of atoms, 0=ch den from wave function 1=read CHGCAR file
    # Add +10 for NSCF calculation e.g. for DOS

    # Stoppping Criteria
    "EDIFF": 1.0e-6,  # Energy Convergence in electronic steps
    "EDIFFG": -1.0e-3,  # Force conv in ionic steps, -ve for force +ve for energy diffrence

    # Smearing
    "ISMEAR": 0,    # 0=Gaussina Smearing, -5: Tetrahedron for DOS
    "SIGMA": 0.05,  # Smearing width

    # Paralalisation
    # "NBANDS": "24"
    "NCORE": "24",
    "KPAR": "1",

    # Dipole Correction
    # "LDIPOL" : ".TRUE.",
    # "IDIPOL" : "3",
    # "DIPOL"  : "0.5 0.5 0.5",

    # Output Setting
    "LVTOT": False,
    "LVHAR": True,
    "LAECHG": True,
    "LWAVE": True,
    "LCHARG": True,
    "LELF": True,
}

scfIncar = Incar(baseIncarProps)
scfIncar.write_file(f"{scfDIR}/INCAR")
scfKpoints.write_file(f"{scfDIR}/KPOINTS")

# Setting for DOS
dosIncarProps = baseIncarProps.copy()
dosIncarProps["ISTART"] = 1
dosIncarProps["ICHARG"] = 11
dosIncarProps["ISMEAR"] = -5
dosIncarProps["LVHAR"] = False
dosIncarProps["LAECHG"] = False
dosIncarProps["LELF"] = False
dosIncar = Incar(dosIncarProps)
dosIncar.write_file(f"{dosDIR}/INCAR")
scfKpoints.write_file(f"{dosDIR}/KPOINTS") # SCF KPOINTS work for dos also

# Setting for Bands
bandsIncarProps = dosIncarProps.copy()
bandsIncarProps["ISMEAR"] = 0
bandsIncar = Incar(bandsIncarProps)
highSymKPath = HighSymmKpath(
    structure=poscar.structure,
    symprec=0.001,
    angle_tolerance=5,
    atol=1e-5,
)
bandsKpoints=Kpoints.automatic_linemode(divisions=40,ibz=highSymKPath)
bandsKpoints.comment="High Symmetry KPath from PYMATGEN modify it as per need"
bandsIncar.write_file(f"{bandsDIR}/INCAR")
bandsKpoints.write_file(f"{bandsDIR}/KPOINTS")


if filterKpoints:
    startLine=17
    data = []
    with open(f"{bandsDIR}/KPOINTS","r+") as fd:
        data = fd.readlines()
        for i in range(startLine-1,len(data)):
            data[i]="#"+data[i] if data[i] != "\n" else data[i]
    
    with open(f"{bandsDIR}/KPOINTS","w") as fd:
        fd.writelines(data)
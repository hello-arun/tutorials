import numpy as np
import ase
import shutil
import os
from pymatgen.core import Structure
from pymatgen.symmetry.analyzer import spglib,SpacegroupAnalyzer
from pymatgen.symmetry.bandstructure import HighSymmKpath
from pymatgen.io.vasp import Kpoints, Poscar
from myTools import Incar
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
systemName = "SnSe"
baseOutDIR=f"{systemName}/10-v3x3-v4"

relaxedPoscarFile = f"{baseOutDIR}/10-relax/calc/fullRelax/CONTCAR"
scfDIR = f"{baseOutDIR}/11-scf/data"
dosDIR = f"{baseOutDIR}/12-dos/data"
bandsDIR = f"{baseOutDIR}/13-bands/data"

potcarFile = f"{os.path.dirname(relaxedPoscarFile)}/POTCAR"
poscar = Poscar.from_file(
    relaxedPoscarFile, check_for_POTCAR=False, read_velocities=False
)
print(poscar.structure)

scfKpoints = Kpoints(
    comment="KPOINTS written by PYMATGEN",
    style="Monkhorst",
    kpts=[[6,6,1]],
    kpts_shift=(0.0,0,0)
    )
# Let us just quickly setup POSCARs and dir 
for DIR in [scfDIR, dosDIR, bandsDIR]:
    os.makedirs(DIR, exist_ok=True)
    shutil.copy(potcarFile, f"{DIR}/POTCAR")
    shutil.copy(relaxedPoscarFile, f"{DIR}/POSCAR")

# For SCF

# We setup first INCAR File
baseIncarProps = f"""# System Setting
    SYSTEM     = XYZ
    PREC       = Accurate   # Accurate works best
    GGA        = PE         # PE=PBE, 91=Perdew-Wang-91
    ENCUT      = 600        # Plane Wave cutoff  

# Type of Calculation
    NSW        = 0          # Max Num of ionic relaxation to perform, 0:SCF 
    ISIF       = 2          # Type of run, 0:MD, 2:Ions relax, 3: Ion+Lattice relax
    IBRION     = -1         # Determines how ions are moved -1=for scf only no update,0:MD, 2:cg algorithm 
    ISPIN      = 1          # 1=spin unpol, 2=spin pol
    ISYM       = 0          # 0: Sym switched off
    # IVDW       = 12         # D3 vdw correction

# Continue or Fresh
    ISTART     = 0          # 0=Scratch, 1=Continuation Job only read wavecar file 
    ICHARG     = 2          # 2=ch den from sup pos of atoms , 0=ch den from wave function 1=read CHGCAR file

# Stopping Criteria
    EDIFF      = 1.0E-6     # Energy Convergence in electronic steps
    EDIFFG     = -1.0E-3    # Force conv in ionic steps, -ve for force +ve for energy diffrence

# Smearing
    ISMEAR     = 0          # 0=Gaussina Smearing
    SIGMA      = 0.05       # Smearing width

# Paralalization
    NCORE      = 32         # No of Cores that will work on each orbital
    KPAR       = 1          # KPoint Parallelization
    # NBANDS     = XX         # No of Bands

# Dos Setting
   # EMIN       = -20        # DOS min
   # EMAX       = 20         # DOS max
   # NEDOS      = 1000       # No of grid points for DOS
   # LORBIT     = 11         # Ideal for projected-DOS

# Dipole Correction
    LDIPOL     = True        # Dipole Correction On
    IDIPOL     = 3           # Direction of Dipole
    DIPOL      = 0.5 0.5 0.5 # Center of Dipole 

# Output Settings
    LVTOT      = False      # Total pot with    Vxc will be written to LOCPOT file for .TRUE.
    LVHAR      = True       # Total pot without Vxc will be written to LOCPOT file for .TRUE.
    LAECHG     = True       # Useful for bader charge analysis
    LWAVE      = True       # Wavecar File
    LCHARG     = True       # Charge Density File
    LELF       = True       # Electron Localization Function

# Extras
"""

scfIncar = Incar(baseIncarProps)
scfIncar.write_file(f"{scfDIR}/INCAR")
scfKpoints.write_file(f"{scfDIR}/KPOINTS")

# Setting for DOS
dosIncar = Incar(baseIncarProps)
dosIncar.set("ISTART", 1)
dosIncar.set("ICHARG", 11)
dosIncar.set("ISMEAR", -5)
dosIncar.set("LVHAR", "False")
dosIncar.set("LAECHG", "False")
dosIncar.set("LELF", "False")

dosIncar.write_file(f"{dosDIR}/INCAR")
scfKpoints.write_file(f"{dosDIR}/KPOINTS") # SCF KPOINTS work for dos also
dosChgcarRef=f"{dosDIR}/chgcarRef"
if not os.path.exists(dosChgcarRef):
    with open(dosChgcarRef,"w") as fd:
        fd.write(f"put-Scf-CHGCAR-Path-Here\n")

# Setting for Bands
dosIncar.set("ISMEAR", 0)
dosIncar.write_file(f"{bandsDIR}/INCAR")
bandsChgcarRef=f"{bandsDIR}/chgcarRef"
if not os.path.exists(bandsChgcarRef):
    with open(bandsChgcarRef,"w") as fd:
        fd.write(f"put-Scf-CHGCAR-Path-Here\n")


highSymKPath = HighSymmKpath(
    structure=poscar.structure,
    # symprec=0.0001,
    # angle_tolerance=5,
    # atol=1e-5,
)
if highSymKPath.kpath is None:
    message="Can not find High Symmetry Path, Use your Own"
    print(message)
    with open(f"{bandsDIR}/KPOINTS.bak","w+") as kptFile:
        kptFile.write(message)
else:
    bandsKpoints=Kpoints.automatic_linemode(divisions=40,ibz=highSymKPath)
    bandsKpoints.comment="High Symmetry KPath from PYMATGEN modify it as per need"
    bandsKpoints.write_file(f"{bandsDIR}/KPOINTS.bak")

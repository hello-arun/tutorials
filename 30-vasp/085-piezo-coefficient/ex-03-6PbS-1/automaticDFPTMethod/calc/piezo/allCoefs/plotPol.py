import numpy as np
import subprocess
from ase.io import vasp
from tabulate import tabulate
piezoTensorClamped = np.zeros((3,6))
piezoTensorIonRlxContribution = np.zeros((3,6))

with open("OUTCAR",'r') as fd:
    lines = fd.readlines()
    clampedMarker = lines.index(" PIEZOELECTRIC TENSOR (including local field effects)  for field in x, y, z        (C/m^2)\n")
    ionicContrMarker = lines.index(" PIEZOELECTRIC TENSOR IONIC CONTR  for field in x, y, z        (C/m^2)\n")
    print(clampedMarker,ionicContrMarker)

    for idx,line in enumerate(lines[clampedMarker+3:clampedMarker+6]):
        piezoTensorClamped[idx] = [float(val) for val in line.strip().split()[1:]]
    for idx,line in enumerate(lines[ionicContrMarker+3:ionicContrMarker+6]):
        piezoTensorIonRlxContribution[idx] = [float(val) for val in line.strip().split()[1:]]
print(f"Clamped Ion ((C/m^2))\n{tabulate(piezoTensorClamped,floatfmt='.3f')}")
print(f"Relax Contr ((C/m^2))\n{tabulate(piezoTensorIonRlxContribution,floatfmt='.3f')}")
c = vasp.read_vasp("./CONTCAR").get_cell().cellpar()[2]

# In Angstrom Column/meter
piezoTensor = (piezoTensorClamped+piezoTensorIonRlxContribution)*c
print(f"Total Contr ((AC/m))\n{tabulate(piezoTensor,floatfmt='.3f')}")

import numpy as np
import subprocess
from ase.io import vasp
from tabulate import tabulate
piezoTensorClamped = np.zeros((3,6))
piezoTensorIonRlxContribution = np.zeros((3,6))

with open("OUTCAR",'r') as fd:
    lines = fd.readlines()
    clampedMarker = lines.index(" PIEZOELECTRIC TENSOR (including local field effects)  for field in x, y, z        (C/m^2)\n")
    print(clampedMarker)

    for idx,line in enumerate(lines[clampedMarker+3:clampedMarker+6]):
        piezoTensorClamped[idx] = [float(val) for val in line.strip().split()[1:]]
print(f"PIEZOELECTRIC TENSOR (ION CLAMPED) ((C/m^2))\n{tabulate(piezoTensorClamped,floatfmt='.3f')}")
c = vasp.read_vasp("./CONTCAR").get_cell().cellpar()[2]
# In Angstrom Column/meter
piezoTensor = (piezoTensorClamped)*c
print(f"PIEZOELECTRIC TENSOR (ION CLAMPED) ((10^{{-10}}C/m))\n{tabulate(piezoTensor,floatfmt='.3f')}")

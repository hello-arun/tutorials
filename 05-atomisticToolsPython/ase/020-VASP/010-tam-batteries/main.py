
from ase.io import vasp
from ase import Atoms
import numpy
import matplotlib.pyplot as plt
import numpy as np

# Reading POSCAR
Y=4
Z=4
data_2L: Atoms = vasp.read_vasp(f"./data/2L.{Y}.K{Z}.vasp")
data_4L: Atoms = vasp.read_vasp(f"./data/4L.1.K0.vasp")

ap_2L = data_2L.get_positions()
ap_4L = data_4L.get_positions()

top_2L = np.where(ap_2L[:, 2] > 2)[0]
top_4L = np.where(ap_4L[:, 2] > 8)[0]

data_2L_top = data_2L[top_2L]
data_4L_top = data_4L[top_4L]
base_2L = np.min(data_2L_top.get_positions()[:, 2])
base_4L = np.min(data_4L_top.get_positions()[:, 2])

# Delete top layer from 4L
del data_4L[top_4L]

# Now extend data from 2L to 4L
shifted_pos_2L = data_2L_top.get_positions()
shifted_pos_2L[:, 2] += base_4L-base_2L  # adjust z cord
data_2L_top.set_positions(shifted_pos_2L)
data_4L.extend(data_2L_top)

vasp.write_vasp(f"./out/4.{Y}.K{4}.vasp",
                atoms=data_4L, label="test", direct=False)

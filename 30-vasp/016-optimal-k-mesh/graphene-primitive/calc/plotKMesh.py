import numpy as np
import matplotlib.pyplot as plt
from ase.io import vasp
from ase import Atoms
import sys

kmesh = np.loadtxt("IBZKPT",comments="#",skiprows=3)
res_lat = np.loadtxt(f"res-lat.csv",comments="#",skiprows=1)
data:Atoms = Atoms(symbols=["H"]*len(kmesh),cell=res_lat*100,pbc=True)
data.set_scaled_positions(kmesh[:,0:3])
data.set_atomic_numbers(kmesh[:,3:].flatten())
vasp.write_vasp("./kmesh-poscar.vasp",atoms=data,direct=True,label="k-mesh")


kmesh = np.dot(kmesh[:,0:3],res_lat)
plt.plot(kmesh[:,0],kmesh[:,1],".")
plt.plot([0,res_lat[0,0]],[0,res_lat[0,1]],"-",label="b1")
plt.plot([0,res_lat[1,0]],[0,res_lat[1,1]],"-",label="b2")
# plt.plot(res_lat[:,0],k_mesh[:,1],".")
# plt.yli*m([-0.8,0.5])
# plt.xlim([-0.6,1.2])
plt.legend()
plt.savefig("fig-kmesh.svg")
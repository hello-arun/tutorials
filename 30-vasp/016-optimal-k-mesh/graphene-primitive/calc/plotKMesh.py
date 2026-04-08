import os
import subprocess
import signal
from itertools import product
import numpy as np
import matplotlib.pyplot as plt
base_dir = "kmesh_study"
vasp_cmd = ["mpirun" ,"-np","16", "/home/migamma/Softwares/vasp.6.4.2/bin/vasp_std"]   # change if needed (e.g., mpirun -np 8 vasp_std)

schemes = ["Gamma", "Monkhorst"]
grids = [
    (4, 4, 1),
    (5, 5, 1),
    (6, 6, 1),
    (7, 7, 1),
]
mm=1/25.4
shifts = ["shift", "no_shift"]
isym_values = [-1, 0, 1, 2]
fig,axes = plt.subplots(8, 8, figsize=(195*mm, 195*mm),sharex="all", sharey="all")
count = 0
for isym, scheme, grid, shift in product(isym_values, schemes, grids, shifts):
    grid_name = f"{grid[0]}x{grid[1]}x{grid[2]}"
    folder = os.path.join(
        base_dir,
        scheme,
        grid_name,
        shift,
        f"ISYM_{isym}"
    )
    direct_lattice = np.zeros((3,3))
    reciprocal_lattice = np.zeros((3,3))
    with open(os.path.join(folder, "OUTCAR"), "r") as fd:
        lines = fd.readlines()
        for idx,line in enumerate(lines):
            if "direct lattice vectors                    reciprocal lattice vectors" in line:
                for i in range(3):
                    vectors = list(map(float, lines[idx+1+i].split()))
                    print(vectors)
                    direct_lattice[i,:] = vectors[0:3]
                    reciprocal_lattice[i,:] = vectors[3:6]
                break
    kmesh = np.loadtxt(os.path.join(folder, "IBZKPT"),comments="#",skiprows=3)
    volume = np.dot(direct_lattice[0], np.cross(direct_lattice[1], direct_lattice[2]))
    print("Direct lattice:")
    print(direct_lattice)
    print("Reciprocal lattice:")
    print(reciprocal_lattice)
    print("Reciprocal lattice (manual):")
    print(np.cross(direct_lattice[1], direct_lattice[2]) / volume)
    print(np.cross(direct_lattice[2], direct_lattice[0]) / volume)
    print(np.cross(direct_lattice[0], direct_lattice[1]) / volume)
    length_reciprocal = np.linalg.norm(reciprocal_lattice, axis=1)
    print("Length of reciprocal lattice vectors:")
    print(length_reciprocal)

    kmesh_cart = np.matmul(kmesh[:,0:3],reciprocal_lattice.T)
    
    row = count // 8
    col = count % 8
    ax = axes[row][col]
    ax.plot([0,reciprocal_lattice[0,0]],[0,reciprocal_lattice[0,1]],"-",label="b1",color="red")
    # ax.plot([0,length_reciprocal[0]],[0,0],"-",label="b1",color="k")
    ax.plot([0,reciprocal_lattice[1,0]],[0,reciprocal_lattice[1,1]],"-",label="b2",color="green")
    ax.scatter(kmesh_cart[:,0],kmesh_cart[:,1],s=1,zorder=10)
    count+=1
    ax.text(0.5, 0.4, f"{scheme}\n{grid_name}+{shift}\nISYM={isym}", transform=ax.transAxes, ha="center", va="top", fontsize=6)    
ax.set_xlim([-length_reciprocal[0], length_reciprocal[0]])
ax.set_ylim([-length_reciprocal[1]*0.90, length_reciprocal[1]*1.10])
plt.subplots_adjust(wspace=0.00, hspace=0.00,left=0,right=1,top=1,bottom=0)
plt.savefig("kmesh_comparison.svg")
# plt.show()
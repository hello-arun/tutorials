import os
from tabulate import tabulate
from itertools import product
import numpy as np
import matplotlib.pyplot as plt
from scipy.spatial import Voronoi


def latticeVectorsFromOutcar(outcarPath):
    dirLattice = np.zeros((3, 3))
    recipLattice = np.zeros((3, 3))
    lenRecipLattice = np.zeros(3)
    with open(outcarPath, "r") as fd:
        lines = fd.readlines()
    for lineIdx, line in enumerate(lines):
        if "direct lattice vectors                    reciprocal lattice vectors" in line:
            for i in range(3):
                vectors = list(map(float, lines[lineIdx + 1 + i].strip().split()))
                print(vectors)
                dirLattice[i, :] = vectors[0:3]
                recipLattice[i, :] = vectors[3:6]
            lenRecipLattice = np.linalg.norm(recipLattice, axis=1)
            volume = np.dot(
                dirLattice[0], np.cross(dirLattice[1], dirLattice[2])
            )
            recipLatticeManual = np.array(
                [
                    np.cross(dirLattice[1], dirLattice[2]) / volume,
                    np.cross(dirLattice[2], dirLattice[0]) / volume,
                    np.cross(dirLattice[0], dirLattice[1]) / volume,
                ]
            )
            print("Direct lattice:")
            print(tabulate(dirLattice))
            print("Reciprocal lattice:")
            print(tabulate(recipLattice))
            print("Reciprocal lattice (manual):")
            print(tabulate(recipLatticeManual))
            print("Length of reciprocal lattice vectors:")
            print(lenRecipLattice)
            return dirLattice, recipLattice, lenRecipLattice

def getBrillouinZone2D(b1, b2):
    points = []
    for i in range(-2, 3):
        for j in range(-2, 3):
            points.append(i * b1 + j * b2)
    points = np.array(points)[:, :2]
    vor = Voronoi(points)
    originIdx = np.where(np.all(np.isclose(points, [0, 0]), axis=1))[0][0]
    rgnIdx = vor.point_region[originIdx]
    region = vor.regions[rgnIdx]
    vertices = vor.vertices[region]
    return vertices

def foldToBZ(k_frac, recipLattice):
    # Convert fractional → Cartesian
    k_carts = np.matmul(k_frac, recipLattice)
    # search nearby reciprocal lattice points
    for idx in range(len(k_carts)):
        min_norm  = np.sum(k_carts[idx]**2)
        best_k = k_carts[idx]
        for n1, n2 in product(range(-1,2), repeat=2):
            G = n1*recipLattice[0] + n2*recipLattice[1]
            k_try = k_carts[idx] + G
            norm = np.sum(k_try**2)
            if norm < min_norm:
                min_norm = norm
                best_k = k_try
        k_carts[idx] = best_k
    return k_carts

base_dir = "kmesh_study"
# change if needed (e.g., mpirun -np 8 vasp_std)
vasp_cmd = ["mpirun", "-np", "16",
            "/home/migamma/Softwares/vasp.6.4.2/bin/vasp_std"]

SCHEMES = ["Gamma", "Monkhorst"]
GRIDS = [
    # (4, 4, 1),
    # (5, 5, 1),
    (6, 6, 1),
    (7, 7, 1),
]
mm = 1 / 25.4
SHIFTS = ["no_shift","shift"]
ISYMS = [0, 2]
fig, axes = plt.subplots(4, 4, figsize=(
    195 * mm, 195 * mm), sharex="all", sharey="all")
calcCount = 0
dirLattice = np.zeros((3, 3))
recipLattice = np.zeros((3, 3))
lenRecipLattice = np.zeros(3)
for shift, scheme, isym, grid in product(SHIFTS, SCHEMES, ISYMS, GRIDS):
    grid_name = f"{grid[0]}x{grid[1]}x{grid[2]}"
    folder = os.path.join(base_dir, scheme, grid_name, shift, f"ISYM_{isym}")
    if np.allclose(dirLattice, 0.0) and np.allclose(recipLattice, 0.0):
            dirLattice, recipLattice, lenRecipLattice = latticeVectorsFromOutcar(os.path.join(folder, "OUTCAR"))
    print(f"Loading IBZKPT from {folder}...")
    kPointsScaled = np.loadtxt(os.path.join(folder, "IBZKPT"), skiprows=3)
    kPoints = np.matmul(kPointsScaled[:, 0:3], recipLattice)
    row = calcCount // 4
    col = calcCount % 4
    ax = axes[row][col]
    ax.plot(
        [0, recipLattice[0, 0]], [0, recipLattice[0, 1]], "-", label="b1", color="red"
    )
    ax.plot(
        [0, recipLattice[1, 0]], [0, recipLattice[1, 1]], "-", label="b2", color="green"
    )
    brillouinZone = getBrillouinZone2D(recipLattice[0], recipLattice[1])
    ax.plot(
        np.append(brillouinZone[:, 0], brillouinZone[0, 0]),
        np.append(brillouinZone[:, 1], brillouinZone[0, 1]),
        "-",
        label="Brillouin Zone",
        color="blue",
    )
    kPointsFolded = foldToBZ(kPointsScaled[:, 0:3], recipLattice)
    ax.scatter(kPointsFolded[:, 0], kPointsFolded[:, 1], s=6, zorder=10,color="k", linewidths=0.5)
    calcCount += 1
    for kpt,weight in zip(kPointsFolded, kPointsScaled[:, 3]):
        ax.text(kpt[0], kpt[1]+lenRecipLattice[1]*0.05, f"{weight:.0f}", fontsize=6, ha="center", va="center",color="black", zorder=20)  
    ax.text(
        0.95,
        0.05,
        f"{scheme[0:4]}\n{grid_name}\n{shift}\nISYM={isym}",
        transform=ax.transAxes,
        ha="right",
        va="bottom",
        fontsize=8,
    )
    for i in range(2):
        ax.text(
            recipLattice[i, 0]-lenRecipLattice[0]*0.02,
            recipLattice[i, 1]-lenRecipLattice[1]*0.2,
            f"$\\vec{{b}}_{{{i+1}}}$",
            ha="right",
            va="bottom",
            fontsize=8,
        )
    # ax.set_xlim([-lenRecipLattice[0], lenRecipLattice[0]])
    # ax.set_ylim([-lenRecipLattice[1]*0.85, lenRecipLattice[1]*1.15])
plt.subplots_adjust(wspace=0.00, hspace=0.00, left=0, right=1, top=1, bottom=0)
plt.savefig("kmeshComparison2.svg")
# plt.show()

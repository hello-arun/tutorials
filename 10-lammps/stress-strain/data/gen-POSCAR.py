# This program generate supercell POSCAR file based on
# Hydrogen Percemtage and supercell parameter(SX,SY)
import sys
import numpy as np
from ase.io import lammpsdata
import ase.atoms as atoms

System = "1T-MoS2"  # Name of system under study
POSCAR_IN = sys.argv[1]  # do not change this
HP = float(sys.argv[2])
SX = int(sys.argv[3])  # supercell factor along x
SY = int(sys.argv[4])  # supercell factor along y
POSCAR_OUT = sys.argv[5]
HEADER = f"System={System}, SX={SX}, SY={SY}, HP={HP:0.2f}%"

np.random.seed(1)  # To reproduce the results
H_S_bl = 1.4  # Hydrogen-Sulfer bond length

unit_cell = lammpsdata.read_lammps_data(POSCAR_IN, style="charge", units="real")
super_cell: atoms = unit_cell * (SX, SY, 1)
atomic_positions = super_cell.get_positions()
atomic_numbers = super_cell.get_atomic_numbers()  # atom types

S_positions = atomic_positions[np.where(atomic_numbers == 2)[0]]
S_no = S_positions.shape[0]  # Total number of Sulfer atoms

H_no = int(S_no * HP / 100)  # We obtain the integer number

H_no_top = H_no // 2
H_no_bot = H_no - H_no_top

S_positions_top = S_positions[S_positions[:, 2] > 10]
S_positions_bot = S_positions[S_positions[:, 2] < 10]

top_indicies = np.random.choice(S_positions_top.shape[0], H_no_top, replace=False)
bot_indicies = np.random.choice(S_positions_bot.shape[0], H_no_bot, replace=False)

# Now we are ready to add Hydrogen
for i in top_indicies:
    # Since if we specify H here then it will confuse with the atom type 1
    super_cell.append("Li")
    super_cell.positions[-1] = S_positions_top[i] + np.array([0, 0, H_S_bl])
for i in bot_indicies:
    super_cell.append("Li")
    super_cell.positions[-1] = S_positions_bot[i] + np.array([0, 0, -H_S_bl])

super_cell.set_initial_charges(super_cell.get_initial_charges() * 0.0)
lammpsdata.write_lammps_data(POSCAR_OUT, super_cell, atom_style="charge")

with open(POSCAR_OUT,"r+") as data:
    lines = data.readlines()
    lines[0] = HEADER
    data.seek(0)
    data.writelines(lines)
    data.truncate()

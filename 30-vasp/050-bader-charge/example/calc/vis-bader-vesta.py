import os
from ase.io import vasp
import numpy as np
from ase import Atoms
zvals = [6,6]  # Z-val of ions in order as in POSCAR
data_bader   = np.loadtxt(fname="BCF.dat",skiprows=2, comments="---", usecols=[4,5])
sort_indices = np.argsort(data_bader[:, 1])  # Get the indices that would sort the 2nd column
charge_bader   = data_bader[sort_indices][:,0]      # Sort the entire array using advanced indexing
print (charge_bader)

atom_nums = np.loadtxt("./POSCAR", skiprows=6, max_rows=1,dtype="int")
start=0
for i in range(len(atom_nums)):
    print(start,start+atom_nums[i],0)
    charge_bader[start:start+atom_nums[i]] = zvals[i]-charge_bader[start:start+atom_nums[i]]
    start += atom_nums[i]
print (charge_bader)

vesta_format="""#VESTA_FORMAT_VERSION 3.5.4

CRYSTAL

TITLE
This is Title Line
CELLP
__cell
  0.000000   0.000000   0.000000   0.000000   0.000000   0.000000
STRUC
__cords
0 0 0 0 0 0 0
"""

with open("bader.vesta","w") as file:
    file.write(vesta_format)

data_vasp:Atoms =  vasp.read_vasp(file="POSCAR")
# data = vasp.read_poscar("./POSCAR")
print(data_vasp)
atomic_numbers=data_vasp.get_atomic_numbers()
atomic_positions = data_vasp.get_scaled_positions()
symbols = data_vasp.get_chemical_symbols()
print(symbols)
print("aji")

cords_str=""
cord_line="{no} {symbol} {name} 1.000 {x} {y} {z} 1a 1\n\n"

for i in range(len(charge_bader)):
    charge=charge_bader[i]
    pos = atomic_positions[i]
    symbol=symbols[i]
    cords_str+=cord_line.format(no=i+1,symbol=symbol,name=f"{charge:0.2f}",x=pos[0],y=pos[1],z=pos[2])

cell=""
for i in data_vasp.cell.cellpar():
    cell+=f"{i} "


line_number = 3

# Define the new line content
new_line = "This is the new line content"

# Read the file contents
with open("bader.vesta", "r") as file:
    lines = file.readlines()

# Modify the line content in memory
lines[8 - 1] =  cell+"\n"
lines[11 -1 ] = cords_str
# Write the modified contents back to the file
with open("bader.vesta", "w") as file:
    file.writelines(lines)


# Created by Arun Jangir, KAUST 2021
"""
This script generate strained POSCAR input file based upon the relaxed base file.

Take four arguments
1st : axis along which to apply strain
2nd : strain percentage
3rd : relaxed CONTCAR file
4th : output file name
"""

import ase.io as io
from ase.build import cut
from ase.io import vasp
import sys

# Collecting command line input
axis = sys.argv[1]                # x y or z
strain = float(sys.argv[2])       # percentage strain
vasp_ref_file_name = sys.argv[3]  # CONTCAR file
output_file_name = sys.argv[4]    # POSCAR OUT FILE

# Setting up some variables for later use
axis_dict = {
    "x": 0,
    "y": 1,
    "z": 2
}
ax_id = axis_dict[axis]

# Getting relaxed unit cell data from the CONTCAR file
vasp_ref_data = io.read(vasp_ref_file_name, format="vasp")
relaxed_unit_cell = vasp_ref_data.get_cell()[:]

# Generating strained unit cell
relaxed_unit_cell[ax_id, ax_id] *= 1+(strain/100.0)
vasp_ref_data.set_cell(relaxed_unit_cell, scale_atoms=True)

# Writing the updated unit cell to output file POSCAR
vasp.write_vasp(output_file_name, vasp_ref_data, direct=True)

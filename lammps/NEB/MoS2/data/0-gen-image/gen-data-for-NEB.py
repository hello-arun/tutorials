# To use this script you first of all need to have a very careful one to one
# mapping of atoms in the unit cell. THIS IS THE MOST CRUCIAL STEP. If you
# do not do it correctly the intermediate images generated will not be correct
# and give undesired results

import ase.io.lammpsdata as lammps
import os
import numpy as np
out_dir = "./out-2H-to-1T"
sx, sy = 46, 30  # supercell x and y
in_file_0 = "./2H-unit-cell.lmp"
in_file_1 = "./1T-unit-cell.lmp"
num_images = 7
image0_lmp = f"{out_dir}/image-0.lmp"
image1_lmp = f"{out_dir}/image-1.lmp"
image1_cord = f"{out_dir}/image-1.cord"

headers = {"image_0": f"2H-MoS2-{sx}x{sy}",
           "image_1": f"1T-MoS2-{sx}x{sy}"}


def write_header(file_name, header):
    """
        This method tries to write header to lmp cord(.lmp) file.
        ASE does not provide any implementation for that
    """
    with open(file_name, "r+") as data:
        lines = data.readlines()
        lines[0] = header
        data.seek(0)
        data.writelines(lines)
        data.truncate()


os.makedirs(out_dir, exist_ok=True)
data_0_in = lammps.read_lammps_data(in_file_0,
                                    units="real",
                                    style="charge"
                                    )
data_1_in = lammps.read_lammps_data(in_file_1,
                                    units="real",
                                    style="charge"
                                    )

data_0_super = data_0_in*(sx, sy, 1)
data_1_super = data_1_in*(sx, sy, 1)
# avg_cell = 0.5*(data_0_super.cell+data_1_super.cell)
# data_0_super.set_cell(avg_cell, scale_atoms=True)

data_1_super.set_cell(data_0_super.cell, scale_atoms=True)
# sorted_data = build.sort(data, tags=-data.positions[:, 2])
lammps.write_lammps_data(image0_lmp,
                         data_0_super,
                         atom_style="charge")
write_header(image0_lmp, headers["image_0"])

lammps.write_lammps_data(image1_lmp,
                         data_1_super,
                         atom_style="charge",
                         )
write_header(image1_lmp, headers["image_1"])

mobile_atoms_indices = np.where(data_1_super.positions[:, 2] < 9)[0]
mob_atoms_final_pos = data_1_super.positions[mobile_atoms_indices]
# id start from 1 rather than 0 so we add 1
mobile_atoms_ids = 1+mobile_atoms_indices

image_1_data = np.concatenate(
    (np.array([mobile_atoms_ids]).T, mob_atoms_final_pos), axis=1)
print(np.array([mobile_atoms_ids]).T.shape)
print(mob_atoms_final_pos.shape)

outfile = open(image1_cord, "w")
outfile.write(f"{len(image_1_data)}\n")
np.savetxt(outfile, image_1_data, fmt="%d %f %f %f")
outfile.close()


# Additional code to write intermediate states also
lammpstrj_format = """ITEM: TIMESTEP
{timestep}
ITEM: NUMBER OF ATOMS
{no_of_atoms}
ITEM: BOX BOUNDS pp pp pp
0 {xhi}
0 {yhi}
0 {zhi}
ITEM: ATOMS id type xs ys zs
"""

num_atoms = len(data_0_super.positions)
xhi = data_0_super.cell[0, 0]
yhi = data_0_super.cell[1, 1]
zhi = data_0_super.cell[2, 2]
with open(out_dir+"/trj.lammpstrj", "w") as trj_file:
    for timestep in range(0, num_images):
        data_int_pos = data_0_super.positions.copy()
        t = timestep/(num_images-1)
        data_int_pos[mobile_atoms_indices] *= (1-t)
        data_int_pos[mobile_atoms_indices] += (t)*mob_atoms_final_pos

        data_int_pos[:, 0] /= xhi
        data_int_pos[:, 1] /= yhi
        data_int_pos[:, 2] /= zhi
        atomid_type_x_y_z = np.zeros((num_atoms, 5))
        atom_ids = np.arange(1, num_atoms+1, 1)
        atom_type = data_0_super.get_atomic_numbers()
        atomid_type_x_y_z[:, 0] = atom_ids
        atomid_type_x_y_z[:, 1] = atom_type
        atomid_type_x_y_z[:, 2:] = data_int_pos

        trj = lammpstrj_format.format(
            timestep=timestep,
            no_of_atoms=num_atoms,
            xhi=xhi, yhi=yhi, zhi=zhi,
        )
        trj_file.write(trj)
        np.savetxt(trj_file, atomid_type_x_y_z, fmt="%d %d %f %f %f")

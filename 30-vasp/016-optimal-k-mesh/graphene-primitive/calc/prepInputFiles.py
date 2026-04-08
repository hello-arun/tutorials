import os
import shutil

# =========================
# USER INPUT
# =========================

base_dir = "kmesh_study"

schemes = {"Gamma": "Gamma", "Monkhorst": "Monkhorst-Pack"}

grids = [
    (4, 4, 1),
    (5, 5, 1),
    (6, 6, 1),
    (7, 7, 1),
]

shifts = {
    "no_shift": (0, 0, 0),
    "shift": (0.5, 0.5, 0),
}

isym_values = [-1, 0, 1, 2]

poscar_src = "POSCAR"
potcar_src = "POTCAR"
incar_template = "INCAR"
vaspRunCommand =  "mpirun -np 36 /home/migamma/Softwares/vasp.6.4.2/bin/vasp_std"

def write_kpoints(filename, scheme, grid, shift):
    with open(filename, "w") as f:
        f.write("KPOINTS generated\n")
        f.write("0\n")
        f.write(f"{scheme}\n")
        f.write(f"{grid[0]} {grid[1]} {grid[2]}\n")
        f.write(f"{shift[0]} {shift[1]} {shift[2]}\n")


def write_incar(filename, isym):
    with open(incar_template, "r") as f:
        lines = f.readlines()
    for i, line in enumerate(lines):
        if "__ISYM__" in line:
            lines[i] = line.replace("__ISYM__", str(isym))
            break

    with open(filename, "w") as f:
        f.writelines(lines)


for scheme_name, scheme_tag in schemes.items():
    for grid in grids:
        grid_name = f"{grid[0]}x{grid[1]}x{grid[2]}"

        for shift_name, shift in shifts.items():
            for isym in isym_values:
                folder = os.path.join(
                    base_dir, scheme_name, grid_name, shift_name, f"ISYM_{isym}"
                )

                os.makedirs(folder, exist_ok=True)

                # Write KPOINTS
                write_kpoints(os.path.join(folder, "KPOINTS"), scheme_tag, grid, shift)

                # Write INCAR
                write_incar(os.path.join(folder, "INCAR"), isym)

                # Copy POSCAR and POTCAR
                if os.path.exists(poscar_src):
                    shutil.copy(poscar_src, os.path.join(folder, "POSCAR"))

                if os.path.exists(potcar_src):
                    shutil.copy(potcar_src, os.path.join(folder, "POTCAR"))

print("All input folders generated successfully!")

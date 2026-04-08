import os
import subprocess
import signal
from itertools import product
base_dir = "kmesh_study"
vasp_cmd = ["mpirun" ,"-np","16", "/home/migamma/Softwares/vasp.6.4.2/bin/vasp_std"]   # change if needed (e.g., mpirun -np 8 vasp_std)

schemes = ["Gamma", "Monkhorst"]

grids = [
    (4, 4, 1),
    (5, 5, 1),
    (6, 6, 1),
    (7, 7, 1),
]

shifts = ["shift", "no_shift"]
isym_values = [-1, 0, 1, 2]

for scheme, grid, shift, isym in product(schemes, grids, shifts, isym_values):
    grid_name = f"{grid[0]}x{grid[1]}x{grid[2]}"
    folder = os.path.join(
        base_dir,
        scheme,
        grid_name,
        shift,
        f"ISYM_{isym}"
    )

    print(f"\n Running: {folder}")

    if not os.path.exists(folder):
        print(" Folder does not exist, skipping")
        continue

    proc = subprocess.Popen(
        vasp_cmd,
        cwd=folder,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )

    try:
        stdout, stderr = proc.communicate(timeout=10)

    except subprocess.TimeoutExpired:
        print("Timeout → terminating...")

        proc.send_signal(signal.SIGTERM)

        try:
            stdout, stderr = proc.communicate(timeout=5)
        except subprocess.TimeoutExpired:
            print(" Force killing...")
            proc.kill()
            stdout, stderr = proc.communicate()

print("\n All manual jobs done!")
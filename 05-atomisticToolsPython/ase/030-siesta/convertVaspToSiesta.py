import sys
from collections import Counter
from ase.io import vasp
from ase.build.tools import sort

def write_fdf_block(fd, block_name, content):
    fd.write(f"%block {block_name}\n")
    fd.write(content)
    fd.write(f"%endblock {block_name}\n")

def main():
    if len(sys.argv) != 3:
        print("Usage: python script.py input_file output_file")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    atoms_vasp_in = vasp.read_vasp(input_file)
    atoms_vasp_in = sort(atoms_vasp_in, tags=atoms_vasp_in.get_atomic_numbers())

    num_atoms = len(atoms_vasp_in)
    cell = atoms_vasp_in.get_cell()
    positions = atoms_vasp_in.get_scaled_positions()
    symbols = atoms_vasp_in.get_chemical_symbols()

    species = {}
    i = 1
    chemical_species = ""
    for atomic_num, symbol in zip(atoms_vasp_in.get_atomic_numbers(), symbols):
        if symbol not in species:
            species[symbol] = {"type": i, "count": 1}
            chemical_species += f"{i:<4d} {atomic_num:<4d} {symbol:<3}\n"
            i += 1
        else:
            species[symbol]["count"] += 1

    num_species = len(species)

    with open(output_file, "w") as fd:
        fd.write("LatticeConstant           1.0 Ang\n")
        fd.write("AtomicCoordinatesFormat   ScaledByLatticeVectors\n")
        fd.write(f"NumberOfAtoms    {num_atoms}\n")
        fd.write(f"NumberOfSpecies    {num_species}\n")
        write_fdf_block(fd, "ChemicalSpeciesLabel", chemical_species)

        lattice_vectors = ""
        for i in range(3):
            lattice_vectors += f"{cell[i, 0]:<016.9f} {cell[i, 1]:<016.9f} {cell[i, 2]:<016.9f}\n"
        write_fdf_block(fd, "LatticeVectors", lattice_vectors)

        atomic_coords_and_species = ""
        for pos, symbol in zip(positions, symbols):
            atomic_coords_and_species += f"{pos[0]:<016.8f} {pos[1]:<016.8f} {pos[2]:<016.8f} {species[symbol]['type']:<3d}\n"
        write_fdf_block(fd, "AtomicCoordinatesAndAtomicSpecies", atomic_coords_and_species)

if __name__ == "__main__":
    main()

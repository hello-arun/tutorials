# Apply Transformation to a input hexagonal Structure to 
# make it Orthogonal

from pymatgen.core import Structure
from pymatgen.symmetry.analyzer import SpacegroupAnalyzer
import argparse


def hexToOrtho(inFile, outFile):
    try:
        poscar: Structure = Structure.from_file(inFile)
        # Return rotated structure
        sga = SpacegroupAnalyzer(poscar, symprec=1e-4)
        poscar = sga.get_refined_structure()
        poscar.make_supercell([[1, 0, 0],
                              [1, 2, 0],
                              [0, 0, 1]])
        poscar.to(filename=outFile, fmt="poscar")
        print(f"Conversion successful. Output saved to {outFile}")
    except Exception as e:
        print(f"An error occurred: {e}")


def main():
    parser = argparse.ArgumentParser(
        description="Convert hexagonal to orthogonal")
    parser.add_argument("--in", dest="iFile",
                        required=True, help="input POSCAR")
    parser.add_argument("--out", dest="oFile",
                        required=True, help="Output file path")
    args = parser.parse_args()
    hexToOrtho(args.iFile, args.oFile)


if __name__ == "__main__":
    main()

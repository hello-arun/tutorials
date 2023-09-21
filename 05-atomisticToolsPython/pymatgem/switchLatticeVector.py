# Rotate the unit cell by 90 Degress to switch lattice vectors a and b

from pymatgen.core import Structure
from pymatgen.transformations.standard_transformations import SymmOp
import argparse

def rotate90(inFile, outFile):
    try:
        poscar:Structure = Structure.from_file(inFile)
        rotaion = SymmOp.from_axis_angle_and_translation(
            axis=[0,0,1],
            angle=90,
        )
        # Return rotated structure
        poscar = poscar.apply_operation(rotaion) 
        poscar.make_supercell(
            [[0,-1,0],
            [1,0,0],
            [0,0,1]]
        )
        poscar.to(filename=outFile,fmt="poscar",)
        print(f"Conversion successful. Output saved to {outFile}")
    except Exception as e:
        print(f"An error occurred: {e}")

def main():
    parser = argparse.ArgumentParser(description="Rotate the unit cell by 90 Degress to switch lattice vectors a and b")
    parser.add_argument("--in", dest="iFile", required=True, help="input POSCAR")
    parser.add_argument("--out", dest="oFile", required=True, help="Output file path")
    args = parser.parse_args()
    rotate90(args.iFile, args.oFile)

if __name__ == "__main__":
    main()

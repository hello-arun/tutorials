from ase.io import vasp
from ase import Atoms
import argparse
from itertools import product
import numpy as np

mote2 = "../1-MoTe2/1Tp/10-relax/calc/fullRelax/CONTCAR"
al2o3 = "./2-Al2O3-surface/0001-surface/10-relax/calc/fullRelax/CONTCAR"

def mapStructures(inFile1,inFile2,maxStrain=0.10,maxAtoms=500,gap=7,maxSupCell=10,vacum=25):
    try:
        atoms0: Atoms = vasp.read_vasp(inFile1)
        atoms1: Atoms = vasp.read_vasp(inFile2)
        
        pos0 = atoms0.get_positions()
        pos1 = atoms1.get_positions()

        min0, max0 = np.min(pos0[:,2]), np.max(pos0[:,2])
        min1, max1 = np.min(pos1[:,2]), np.max(pos1[:,2])
        # atoms0.set_positions(pos0-np.min(pos0[:,2]))
        # atoms1.set_positions(pos1-np.min(pos1[:,2]))

        thickness = gap+max0-min0+max1-min1
        c_final = thickness+vacum
        
        offset0 = c_final*0.5-thickness*0.5-min0
        offset1 = c_final*0.5+thickness*0.5-max1
        N0, N1 = len(atoms0), len(atoms1)
        [a0,b0,c0,*_] = atoms0.get_cell().cellpar()
        [a1,b1,c1,*_] = atoms1.get_cell().cellpar()
        atoms0.set_cell([a0,b0,c_final],scale_atoms=False)
        atoms0.set_positions(pos0+[0,0,offset0])
        atoms1.set_positions(pos1+[0,0,offset1])
        for sx0, sy0, sx1, sy1 in product(range(1, maxSupCell+1), repeat=4):
            numAtoms = sx0*sy0*N0 + sx1*sy1*N1
            if numAtoms > maxAtoms:
                continue
            epX = abs(sx0*a0-sx1*a1)/(sx1*a1)
            epY = abs(sy0*b0-sy1*b1)/(sy1*b1)
            if epX>maxStrain or epY > maxStrain:
                continue
            print(f"{sx0}x{sy0}-{sx1}x{sy1}-: numAtoms:{numAtoms} epsilon:{epX:0.2f},{epY:0.2f}")
            atomsFinal:Atoms=atoms0*(sx0,sy0,1)
            for atom in atoms1*(sx1,sy1,1):
                atomsFinal.append(atom)
            print(f"Writing {sx0}x{sy0}-{sx1}x{sy1} numAtoms: {len(atomsFinal)}")
            
            vasp.write_vasp(file=f"./POSCAR-{sx0}x{sy0}-{sx1}x{sy1}.vasp",atoms=atomsFinal,sort=True)
    except Exception as e:
        print(f"An error occurred: {e}")    


def main():
    parser = argparse.ArgumentParser(
        description="Convert hexagonal to orthogonal")
    parser.add_argument("--in1", dest="in1",
                        required=True, help="input POSCAR1")
    parser.add_argument("--in2", dest="in2",
                        required=True, help="intput POSCAR2")
    parser.add_argument("--maxStrain", dest="maxStrain",
                        required=True, help="maximum Strain",default=0.10)
    parser.add_argument("--maxAtoms", dest="maxAtoms",
                        required=True, help="maximum Atoms to include",default=500)
    parser.add_argument("--gap", dest="gap",
                        required=True, help="gap to keep between structure",default=7)
    args = parser.parse_args()
    mapStructures(args.in1, args.in2,args.maxStrain,args.maxAtoms,args.gap,10)


if __name__ == "__main__":
    main()
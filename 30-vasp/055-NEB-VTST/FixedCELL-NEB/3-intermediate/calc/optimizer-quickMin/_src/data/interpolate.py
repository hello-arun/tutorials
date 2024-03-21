from ase.io import vasp
import os 


dataI=vasp.read_vasp(f"POSCAR-i.vasp")
dataF=vasp.read_vasp(f"POSCAR-f.vasp")
numIntermImgs=3 # This should be equal to IMAGES in INCAR

visDIR="./vis"
os.makedirs(visDIR,exist_ok=True)
dataM=dataI.copy()
posI=dataI.get_positions()
posF=dataF.get_positions()

for i in range(numIntermImgs+2):
    print(f"Genrating Image: {i:02d}")
    outDIR=f"./{i:02d}"
    os.makedirs(outDIR,exist_ok=True)
    pos=posI+(posF-posI)*i/(numIntermImgs+1)
    dataM.set_positions(pos)
    vasp.write_vasp(f"{outDIR}/POSCAR",dataM,direct=False)
    vasp.write_vasp(f"{visDIR}/img-{i:02d}.vasp",dataM,direct=False)


print("Done!!")
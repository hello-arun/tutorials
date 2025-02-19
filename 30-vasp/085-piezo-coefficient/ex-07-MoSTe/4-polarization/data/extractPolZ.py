import numpy as np
from pymatgen.io.vasp import Chgcar,Poscar
from ase.io import vasp
import os
import pandas as pd
def isRelaxed(outcar):
    with open(outcar,"r") as fd:
        return "reached required accuracy"  in fd.read()

cwd=os.getcwd()
strains=np.linspace(-0.005,0.005,11)
assert (cwd[-7:] == "strainX") or (cwd[-7:] == "strainY")
strainAxis=cwd[-1]
chargeDict={}
with open("./POTCAR","r") as fd:
    lines=fd.readlines()
    for line in lines:
        if "TITEL" in line:
            element = line.strip().split()[-2]
        if "ZVAL" in line:
            chargeDict[element]=float(line.strip().split()[5])    
    print(chargeDict)
dataPols=[]

for strain in strains:
    if abs(strain)<1e-6:
        strain=0
    strainDIR=f"./{strain:.3f}"
    outcarFile=f"{strainDIR}/OUTCAR"
    chgcarFile=f"{strainDIR}/CHGCAR"
    if not os.path.exists(outcarFile):
        print(f"{outcarFile} does not exist")
        continue
    if not isRelaxed(outcarFile):
        print(f"{outcarFile} is not relaxed!")
        continue
    if not os.path.exists(chgcarFile):
        print(f"{chgcarFile} does not exist!")
    chgcar:Chgcar = Chgcar.from_file(f"{strainDIR}/CHGCAR")
    poscar:Poscar = chgcar.poscar
    data = chgcar.data['total']
    chargeElec = data/np.prod(data.shape)
    totalChargeElectrons,totalChargeIons = np.sum(chargeElec),0.0
    gridShape = data.shape

    
    a,b,c = poscar.structure.lattice.lengths
    positions= poscar.structure.cart_coords
    pIon = np.array([0.,0,0])
    for site in poscar.structure:
        pIon += np.array(site.coords)*chargeDict[site.specie.symbol]
        totalChargeIons += chargeDict[site.specie.symbol]

    assert np.isclose(totalChargeElectrons,totalChargeIons,atol=1e-5)

    xCords = np.linspace(0,a,gridShape[0],endpoint=False)[:, None, None]  # Reshape to (Nx, 1, 1)
    yCords = np.linspace(0,b,gridShape[1],endpoint=False)[None, :, None]  # Reshape to (1, Ny, 1)
    zCords = np.linspace(0,c,gridShape[2],endpoint=False)[None, None, :]  # Reshape to (1, 1, Nz)
    pEle = np.array([0.0,0,0])
    pEle = np.array([
        np.sum(xCords * chargeElec),
        np.sum(yCords * chargeElec),
        np.sum(zCords * chargeElec)
    ])
    dataPol={
        'polAxis':3,
        'epsilon':strain,
        'pIon':-pIon[2], # unit e*Ang,
        'pEle': pEle[2], # unit e*Ang,
        'vol':poscar.structure.lattice.volume,
        'a':poscar.structure.lattice.a,
        'b':poscar.structure.lattice.b,
        'c':poscar.structure.lattice.c,
        'shift':0
    }
    print(dataPol)
    dataPols.append(dataPol)

df = pd.DataFrame(dataPols)
df.to_csv("polZ.csv",index=False)
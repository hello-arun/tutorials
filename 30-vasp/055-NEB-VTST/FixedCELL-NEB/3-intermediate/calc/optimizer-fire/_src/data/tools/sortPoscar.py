from ase.io import vasp
from ase.build import sort
import numpy as np
import pandas as pd
dataF=vasp.read_vasp("./POSCAR-f.vasp")
numInterMediate=8

for key in ["i","f"]:
    data=vasp.read_vasp(f"POSCAR-{key}.vasp")
    df=pd.DataFrame(columns=["symbol","x","y","z"])
    for atom in data:
        df.loc[len(df)]=[atom.symbol,atom.x,atom.y,atom.z]
    print(df)
    df=df.sort_values(by=["symbol","x","y","z"],ascending=[True,True,True,True])
    print(df.index)
    zero=data.get_positions()[df.index[0]]
    zero[2]=0
    data.set_positions(data.get_positions()-zero)
    # scaledPos=data.get_scaled_positions()
    

    # data=sort(data,tags=df.index.values)
    vasp.write_vasp(f"POSCAR-s{key}.vasp",data,direct=True,sort=[df.index.values],wrap=True)
        # vasp.write_vasp(f"POSCAR-s{key}.vasp",dataF)
# nums=range(len(dataF.get_number_of_atoms()))
# nums = sorted(nums, key=lambda atom: (atom.symbol, atom.position[2], atom.position[1], atom.position[0]))
# print(nums)
# assert np.allclose(dataI.get_cell().cellpar(),dataF.get_cell().cellpar(),atol=0.002)



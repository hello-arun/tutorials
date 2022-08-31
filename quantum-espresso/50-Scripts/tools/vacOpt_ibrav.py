#!/home/jangira/.conda/envs/py3/bin/python
import numpy as np
import argparse 
import re
parser=argparse.ArgumentParser(description="This python script will create structure with given vaccum spacing between its layers")
parser.add_argument("--inFile",help="input file",required=True)
parser.add_argument("--outFile",help="output file",required=True)
parser.add_argument("--vac",help="vacuum to create",required=True,type=float)
parser.add_argument("--shift",help="shift in angastrom from middle",default=0.0,type=float)

args = parser.parse_args()
def indiciesOf(string, array):
    return  [j for j,i in enumerate(array) if string in i] 
scf_in_name=args.inFile
scf_out = open(args.outFile,'w')
scf_in = open(scf_in_name,'r+')
data = scf_in.readlines()

atom_pos = indiciesOf("ATOMIC_POSITIONS",data)[0]
c_pos = indiciesOf("c           =",data)[0]

c = float(data[c_pos].split()[2])
scf_in.close()


i=0

target_vacuum=args.vac

atom_coords = np.loadtxt(scf_in_name,skiprows=atom_pos+1,usecols=[2,3])
data_complete = np.loadtxt(scf_in_name,skiprows=atom_pos+1,dtype=str)
print(data_complete)
print(atom_coords)
atom_coords[:,1] = atom_coords[:,1]*c

z_min = min(atom_coords[:,1])
z_max = max(atom_coords[:,1])
material_height = (z_max-z_min)
cell_height = material_height+target_vacuum
data[c_pos]=f"    c           = {cell_height:0.2f}  !\n"


shift = cell_height/2-material_height/2-z_min

atom_coords[:,1] += shift+args.shift
atom_coords[:,1] /= cell_height

scf_out.writelines(data[0:atom_pos])


data_complete[:,2:] = atom_coords
scf_out.write("\nATOMIC_POSITIONS (crystal)\n")
np.savetxt(scf_out,data_complete,fmt="%s")

scf_out.close()

print("###########################################")

eamp=0
emaxpos=0
eopreg=0
#!/home/jangira/miniconda3/envs/ASE/bin/python
import numpy as np
import argparse 
def indiciesOf(string, array):
    return  [j for j,i in enumerate(array) if string in i] 

parser=argparse.ArgumentParser(description="This python script will create structure with given vaccum spacing between its layers")
parser.add_argument("--inFile",help="input file",required=True)
parser.add_argument("--outFile",help="output file",required=True)
parser.add_argument("--vac",help="vacuum to create",required=True,type=float)
parser.add_argument("--shift",help="shift in angastrom from middle",default=0.0,type=float)
parser.add_argument("--gap",help="gap",default=0.0,type=float)
parser.add_argument("--width",help="width of",default=0.0,type=float)
args = parser.parse_args()


scf_in_name=args.inFile
scf_out = open(args.outFile,'w')
scf_in = open(scf_in_name,'r+')
data = scf_in.readlines()
atom_pos = indiciesOf("ATOMIC_POSITIONS",data)[0]
cell_param_pos = indiciesOf("CELL_PARAM",data)[0]
scf_in.close()
i=0
scf_out.writelines(data[0:cell_param_pos+1])



target_vacuum=args.vac


cell_params = np.loadtxt(scf_in_name ,skiprows = cell_param_pos + 1, max_rows = atom_pos - cell_param_pos - 1, usecols = [0,1,2])
data = np.loadtxt(scf_in_name,skiprows=atom_pos+1,usecols=[1, 2, 3])


data_complete = np.loadtxt(scf_in_name,skiprows=atom_pos+1,dtype=str)
data[:,2]=data[:,2]*cell_params[2,2]

z_min = min(data[:,2])
z_max = max(data[:,2])


material_height = (z_max-z_min)
cell_height = material_height+target_vacuum
print(cell_height)

shift = cell_height/2-material_height/2-z_min

data[:,2] += shift+args.shift
z_min = min(data[:,2])
emaxpos=(z_min-args.gap)/cell_height


data[:,2] /= cell_height
cell_params[2,2]=cell_height
print(cell_params)
print(data)
print(shift)

np.savetxt(scf_out,cell_params,fmt="%0.6f")
data_complete[:,1:] = data
scf_out.write("\nATOMIC_POSITIONS (crystal)\n")
np.savetxt(scf_out,data_complete,fmt="%s")

scf_out.close()

print(f"##################{args.outFile}#####################")

eopreg=args.width/cell_height

print(f"emaxpos = {emaxpos:0.3f}")
print(f"eopreg = {eopreg:0.3f}")


print(f"###################{args.outFile}########################")

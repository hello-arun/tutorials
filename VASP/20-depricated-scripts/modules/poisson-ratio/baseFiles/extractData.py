##This Script file extract data from different relax output files and calculates the lx ly and lz for these cases
import numpy as np
import os
import sys

def extractAlong(axis):
    datas = []
    strainInputs = open(f"strain{axis}Inputs.txt","r+")
    output = open(f"./postProcessing/strain_{axis}_data.txt","w+")
    strains = strainInputs.read().split()
    for strain in strains:
        data = [strain]
        try:
            relax_file_name=f"./relax.{axis}{strain}/relax.out"
            f4 = open(relax_file_name,"r+")
            a = f4.readlines()
            start = a.index("Begin final coordinates\n")+5
            end = a.index("End final coordinates\n")
            a = a[start:end]
            data.append(a[0].split()[0])  # this is lx being appended
            data.append(a[1].split()[1])  # this is ly being appended
            zz = (a[2].split()[2])
            zz=float(zz)
            a = np.loadtxt(relax_file_name,skiprows=start+5,max_rows = end-start-5,usecols=[1,2,3])
            data.append(zz*(np.amax(a[:,2])-np.amin(a[:,2]))) # this is lz( this may differ for different cases)
            f4.close()
        except:
            data = [f"#{strain}",'data','not','found']
        datas.append(data)
    np.savetxt(output,datas,fmt="%s")
    output.close()
    strainInputs.close()

# mol = sys.argv[1]
axis = sys.argv[1].upper()

if not os.path.isdir('./postProcessing'):
    os.mkdir('./postProcessing')
if(axis=='X'):
    extractAlong('X')
elif(axis=='Y'):
    extractAlong('Y')
elif(axis=='XY' or axis=='YX'):
    extractAlong('Y')
    extractAlong('X')
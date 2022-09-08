##This Script file extract data from different relax output files and calculates the lx ly and lz for these cases
import numpy as np
import os
import sys
import math
import argparse
import traceback
import pylint
argParse = argparse.ArgumentParser()

## Lets define differrent angle pairs.
## The atoms on boundary might go to the other side so we explicitly define which atom we really want
## Direction Horizontal -->> Left to right
## Direction vertical top to bottom -->> Left to Right 

comment=["# Strain", "M_Top", "M_Bottom",   "X_Top",      "X_Bottom","Y_behind"]  
pairs=np.array([ [3,2,4],   [3,1,'4-r0'],  [1,3,2],   [1,'4-r0','2-r0'],[2,3,'2-0r']])

parser = argparse.ArgumentParser(description='This will extract different angles from structure')
parser.add_argument('--i',help="Folder containing relax.out Files",  default="../")
parser.add_argument('--o',help="postProcessing Folder where data needs to be stored",  default="../postProcessing")
parser.add_argument('--axis',help="Axis along which calculations are completed",  default="X")
parser.add_argument('--thr',help="threshold", type=float,default=0.2)

args = parser.parse_args()


# 3 2 4 Theta M
# 1 3 2 Theta X

def extractAlong(axis,pairs,thr):
    pairs=np.array(pairs)
    datas = [comment]
    strainInputs = open(f"{args.i}/strain{axis}Inputs.txt","r+")
    strains = strainInputs.read().split()
    for strain in strains:
        data = [strain]
        try:
            fileName=f"{args.i}/relax.{axis}{strain}.out"
            f4 = open(fileName,"r+")
            a = f4.readlines()
            start = a.index("Begin final coordinates\n")
            end = a.index("End final coordinates\n")
            f4.close()
            crystal=np.loadtxt(fileName,skiprows=start+5,max_rows=3)
            crystal=np.transpose(crystal)
            atoms=np.loadtxt(fileName,skiprows=start+10,max_rows = end-start-10,usecols=[1,2,3], comments="E")
            for pair in pairs:
                print(pair)
                atooms=atoms.copy()
                pai=np.zeros((3,3))
                for i in range(3):
                    mark = pair[i].find("-")
                    if mark != -1:
                        value = pair[i][:mark]
                        value=int(value)-1
                        pai[i]=value
                        x=atoms[value,0]
                        y=atoms[value,1]
                        z=atoms[value,2]

                        if(pair[i][mark+1]=='r'):
                            x=x+1
                        elif( pair[i][mark+1]=='l'):
                            x=x-1
                        if(pair[i][mark+2]=='r'):
                            y=y+1
                        elif(pair[i][mark+2]=='l'):
                            y=y-1
                        pai[i,:] = np.array([x,y,z])
                        # atooms[value,0]=x
                        # atooms[value,1]=y
                    else:
                        value=int(pair[i])-1
                        pai[i] = atooms[value,:]
                        # pai[i]=value-1
                atooms=np.matmul(pai,crystal)
                vec1 = atooms[0,:]-atooms[1,:]
                vec1 = vec1/np.linalg.norm(vec1)
                vec2 = atooms[2,:]-atooms[1,:]
                vec2 = vec2/np.linalg.norm(vec2)
                theta=np.arccos(np.dot(vec1,vec2))
                theta=math.degrees(theta)
                print(f"{strain} {pair} {theta}")
                data.append(theta)
        except Exception:
            data = [f"#{strain}",'data','not','found',sys.exc_info()[0]]
            print(traceback.format_exc())
            print(sys.exc_info()[2])
        datas.append(data)
    np.savetxt(f"{args.o}/strain_{axis}_angle_data.dat",datas,fmt="%s")
    strainInputs.close()
axis = args.axis.upper()
if not os.path.isdir(args.o):
    os.mkdir(args.o)
if(axis=='X'):
    extractAlong('X',pairs,args.thr)
elif(axis=='Y'):
    extractAlong('Y',args.thr)
elif(axis=='XY' or axis=='YX'):
    extractAlong('Y',pairs,args.thr)
    extractAlong('X',pairs,args.thr)
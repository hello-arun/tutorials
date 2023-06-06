import numpy as np
import os
import sys


def extractAlong(axis):
    outputFile = open(f'./postProcessing/{mol}.strain_{axis}.lmpstrj','w+')
    timestep = 1
    atom_ids = {}
    id = 1
    strainInputs = open(f"{mol}.strain{axis}Inputs.txt","r+")
    strains = strainInputs.read().split()
    for strain in strains:
        filename = f'{mol}.relax.{axis}{strain}.out'
        f4 = open(filename,'r+')
        idata = f4.readlines()
        marker1 = idata.index('Begin final coordinates\n')+5
        marker2 = idata.index('End final coordinates\n')
        cellParams = np.loadtxt(filename,skiprows=marker1,max_rows=3)
        atoms = np.loadtxt(filename,skiprows=marker1+5,max_rows=marker2-marker1-5,usecols=[0],dtype = str)
        if timestep == 1:
            for atom in atoms:
                if not atom in atom_ids:
                    atom_ids[atom] = id
                    id+=1
        coordinates = np.loadtxt(filename,skiprows=marker1+5,max_rows=marker2-marker1-5,usecols=[1,2,3])

        outputFile.write(f'ITEM: TIMESTEP\n{timestep}\n')
        timestep += 1
        outputFile.write("ITEM: NUMBER OF ATOMS\n")
        outputFile.write(f'{len(atoms)}\n')
        outputFile.write("ITEM: BOX BOUNDS pp pp ss\n")

        for i in range(3):
            outputFile.write(f'0.0  {cellParams[i,i]}\n')

        outputFile.write("ITEM: ATOMS id type xs ys zs\n")

        for i in range(len(atoms)):
            outputFile.write(f'{i+1} {atom_ids[atoms[i]]} {coordinates[i][0]} {coordinates[i][1]} {coordinates[i][2]} \n')
    outputFile.close()


mol = sys.argv[1]
axis = sys.argv[2].upper()
if not os.path.isdir('./postProcessing'):
    os.mkdir('./postProcessing')
if(axis=='X'):
    extractAlong('X')
elif(axis=='Y'):
    extractAlong('Y')
elif(axis=='XY' or axis=='YX'):
    extractAlong('Y')
    extractAlong('X')

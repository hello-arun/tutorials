#!/home/jangira/.conda/envs/py3/bin/python
import numpy as np
from matplotlib import pyplot as plt
import sys
import os
fig, (ax1,ax2) = plt.subplots(1,2)
try:
    quantity=sys.argv[1] ## quantity to plot eamp ot tot_charge or anything
    folder=sys.argv[2]   ## folder containg list infor generally ../postProcessing
    ref=sys.argv[3]
except:
    print("Not Enough Argument Passed")
    print("1 : Quantity (eamp or tot_charge or anyother)\n2 : Folder(postProcessing)")
    print("Now exiting...")
    print("Program Ended")
    print("################################")
    exit()
print("################################")
print("Program Started")
print("################################")

print(os.getcwd())

ax1.set_xlabel(f"Cell Param along Z ($\AA$)")
ax1.set_ylabel("Avg. pot. (Ry)")
try:
    fileNames = np.loadtxt(f'{folder}/{quantity}_list.sh',dtype=str,ndmin=1)
    referenceData = np.loadtxt(f'{folder}/avg.{quantity}_{ref}.sh')
    efs=open(f'{folder}/avg.{quantity}_{ref}.sh').readline().split()
    for ef in efs:
        try:
            ef=float(ef)
            print(f"Fermi energy is {ef} (ev)")
            ax1.plot(referenceData[:,0]*0.529,referenceData[:,1]*0.0+float(ef)/13.6,'--k')

            break
        except:
            continue
except OSError as er:
    print(er)
    print("Now exiting...")
    print("Program Ended")
    print("################################")
    exit()
print(f'FileNames are...')
print(f'{fileNames}')
for fileName in fileNames:
    print(f"Trying for {fileName}")
    try:
        data = np.loadtxt(f'{folder}/avg.{fileName}.sh')
        p=ax1.plot(data[:,0]*0.529,data[:,1],label = f'ef_{fileName}')
        
        slope=np.gradient(data[:,1]-referenceData[:,1],data[:,0])
        ax2.plot(data[:,0]*0.529,slope/2)
    except OSError as er:
        print(er)
        print(f'Error on line {sys.exc_info()[-1].tb_lineno}')
    except ValueError as er:
        print(er)
        print(f'Error on line {sys.exc_info()[-1].tb_lineno}')
    print("............................")

ax1.legend()
ax1.grid()
ax2.grid()
ax2.set_ylim([-0.001,0.020])
ax2.set_yticks(np.arange(-0.001,0.020,step=0.001))
plt.show()
print("################################")
print("Program Ended..")
print("################################")
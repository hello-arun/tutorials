#!/home/jangira/.conda/envs/py3/bin/python
import numpy as np
from matplotlib import pyplot as plt
import sys
import os
fact = 1.8
# fig = plt.figure()
fig, (ax1,ax2) = plt.subplots(1,2,figsize=(19.2/fact,10.8/fact), dpi=100*fact)

try:
    quantity=sys.argv[1] ## quantity to plot eamp ot tot_charge or anything
    folder=sys.argv[2]   ## folder containg list infor generally ../postProcessing
    ref=sys.argv[3]
    prefix=sys.argv[4]
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
    referenceData = np.loadtxt(f'{folder}/avg_{prefix}.{quantity}_{ref}.sh')
    efs=open(f'{folder}/avg_{prefix}.{quantity}_{ref}.sh').readline().split()
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
data = np.loadtxt(f'{folder}/avg_{prefix}.eamp_0.000.sh')
arr=np.empty((len(data[:,0]),1))
arr[:,0] = data[:,0]*0.529
for fileName in fileNames:
    print(f"Trying for {fileName}")
    try:
        data = np.loadtxt(f'{folder}/avg_{prefix}.{fileName}.sh')
        p=ax1.plot(data[:,0]*0.529,data[:,2],label = f'ef_{fileName}')
        
        slope=np.gradient(data[:,2]-referenceData[:,2],data[:,0])
        ax2.plot(data[:,0]*0.529,slope/2)
        arr = np.insert(arr,np.shape(arr)[1], slope/2, axis=1)
        np.savetxt("data.dat",arr)
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
ax2.set_ylim([-0.001,0.024])
ax2.set_yticks(np.arange(-0.001,0.020,step=0.001))
plt.show()
fig.savefig("plot.png")
print("################################")
print("Program Ended..")
print("################################")

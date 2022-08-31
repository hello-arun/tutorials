import numpy as np
import matplotlib.pyplot as plt
ppFolder="../postProcessing"
qty="eamp"

x=np.loadtxt(f"{ppFolder}/{qty}_list.sh",dtype=str)
data = np.empty((0,5), float)
fig,ax=plt.subplots(1,2)
for i in x:
    i=float(i.replace("eamp_",""))
    dat=np.loadtxt(f"{ppFolder}/{qty}/ACF_{i:0.5f}.dat",skiprows=2,max_rows=4,usecols=[4])
    data = np.append(data, np.array([[i,dat[0],dat[1],dat[2],dat[3]]]), axis=0)
np.set_printoptions(formatter={'all':lambda x: f"{x:0.3f}"})
print(data)
ax[0].plot(data[:,0]*514.22*11/8,data[:,1],label="Ge_B")  #Bottom
ax[0].plot(data[:,0]*514.22*11/8,data[:,2],label="Ge_T")  
ax[1].plot(data[:,0]*514.22*11/8,data[:,4],label="S_B")
ax[1].plot(data[:,0]*514.22*11/8,data[:,3],label="S_T")
for a in ax:
    a.legend()
    plt.savefig("../charge.png")
plt.tight_layout()
plt.show()

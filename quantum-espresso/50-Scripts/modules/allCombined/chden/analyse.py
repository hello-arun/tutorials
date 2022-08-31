import numpy as np
import matplotlib.pyplot as plt
ppFolder="../postProcessing"
qty="eamp"

x=np.loadtxt(f"{ppFolder}/{qty}/list.sh")
data = np.empty((0,5), float)
fig,ax=plt.subplots(1,2)
for i in x:
    dat=np.loadtxt(f"{ppFolder}/{qty}/ACF_{i:0.3f}.dat",skiprows=2,max_rows=4,usecols=[4])
    data = np.append(data, np.array([[i,dat[0],dat[1],dat[2],dat[3]]]), axis=0)
np.set_printoptions(formatter={'all':lambda x: f"{x:0.3f}"})
print(data)
ax[0].plot(data[:,0],data[:,1],label="M_B")  #Bottom
ax[0].plot(data[:,0],data[:,2],label="M_T")  
ax[1].plot(data[:,0],data[:,4],label="X_B")
ax[1].plot(data[:,0],data[:,3],label="X_T")
for a in ax:
    a.legend()
plt.show()
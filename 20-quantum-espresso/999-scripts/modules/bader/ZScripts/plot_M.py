#!/home/jangira/.conda/envs/py3/bin/python
import numpy as np
import numpy.polynomial as polynomial
import matplotlib.pyplot as plt
from matplotlib.ticker import (MultipleLocator, AutoMinorLocator)
import sys

mm=1/25.4
plt.style.use('plot_style.txt')
fig,(ax1) = plt.subplots(1,1)
fig.set_size_inches(89*mm,75*mm)

ax1.set_xlabel(f'Electric field (V/nm)')
ax1.set_ylabel(f'Bader charge')

ax1.xaxis.set_major_locator(MultipleLocator(2))
ax1.xaxis.set_minor_locator(MultipleLocator(0.5))

ax1.yaxis.set_major_locator(MultipleLocator(0.02))
ax1.yaxis.set_minor_locator(MultipleLocator(0.005))

ax1.set_xlim([-0.5,11.5])
ax1.set_ylim([3.13,3.25])


ax1.xaxis.set_ticks_position('both')
ax1.yaxis.set_ticks_position('both')
ppFolder="../postProcessing"
qty="eamp"

x=np.loadtxt(f"{ppFolder}/{qty}_list.sh",dtype=str)
data = np.empty((0,5), float)
for i in x:
    i=(i.replace("eamp_",""))
    dat=np.loadtxt(f"{ppFolder}/{qty}/ACF_{i}.dat",skiprows=2,max_rows=4,usecols=[4])
    data = np.append(data, np.array([[float(i),dat[0],dat[1],dat[2],dat[3]]]), axis=0)
np.set_printoptions(formatter={'all':lambda x: f"{x:0.3f}"})
print(data)
ax1.plot(data[:,0]*514.22*11/8,data[:,2],".-",label=r"$\mathregular{M_T}$")  
ax1.plot(data[:,0]*514.22*11/8,data[:,1],".-",label=r"$\mathregular{M_B}$")  #Bottomw
# ax[1].plot(data[:,0]*514.22*11/8,data[:,4],label="S_B")
# ax[1].plot(data[:,0]*514.22*11/8,data[:,3],label="S_T")
ax1.legend()
plt.tight_layout()
plt.savefig("../chargeM.svg")
plt.show()

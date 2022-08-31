import numpy as np
import sys
import matplotlib.pyplot as plt

# Takes two argument 
# First is frefix of .gp file
# second is optional 0 or 1 
# 0 : THz freq unit
# 1 : cm-1 freq unit

prefix = sys.argv[1]
units=["THz","$cm^-1$"]
factors=[0.02998,1.0]
unit=0
if(len(sys.argv)>2):
    unit=int(sys.argv[2])

data = np.loadtxt(f"{prefix}.freq.gp")
plt.plot(data[:,0],data[:,1:]*factors[unit])
plt.plot(data[:,0],data[:,0]*0.0,"--")

plt.ylabel(units[unit])
plt.show()

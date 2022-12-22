import numpy as np
import matplotlib.pyplot as plt
data = np.loadtxt("PLANAR_AVERAGE.dat")
plt.plot(data[:,0],data[:,1])
plt.ylabel("Average Potential")
plt.xlabel("Lattice Cordinate")
plt.show()

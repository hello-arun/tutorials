from cgitb import reset
import numpy as np
import matplotlib.pyplot as plt
k_mesh = np.loadtxt(f"k-mesh.csv",comments="#")
res_lat = np.loadtxt(f"res-lat.csv",comments="#")
plt.plot(k_mesh[:,0],k_mesh[:,1],".")
plt.plot([0,res_lat[0,0]],[0,res_lat[0,1]],"-")
plt.plot([0,res_lat[1,0]],[0,res_lat[1,1]],"-")
# plt.plot(res_lat[:,0],k_mesh[:,1],".")
# plt.yli*m([-0.8,0.5])
# plt.xlim([-0.6,1.2])
plt.savefig(f"k-mesh-5x5-nosym-nosym_evc-noinv.png")
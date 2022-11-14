from cgitb import reset
import numpy as np
import matplotlib.pyplot as plt
import sys
k_mesh = np.loadtxt("IBZKPT",comments="#",skiprows=3)
res_lat = np.loadtxt(f"res-lat.csv",comments="#",skiprows=1)
k_mesh = np.dot(k_mesh[:,:3],res_lat)
plt.plot(k_mesh[:,0],k_mesh[:,1],".")
plt.plot([0,res_lat[0,0]],[0,res_lat[0,1]],"-",label="b1")
plt.plot([0,res_lat[1,0]],[0,res_lat[1,1]],"-",label="b2")
# plt.plot(res_lat[:,0],k_mesh[:,1],".")
# plt.yli*m([-0.8,0.5])
# plt.xlim([-0.6,1.2])
plt.legend()
plt.savefig(f"k-mesh-{sys.argv[1]}.png")
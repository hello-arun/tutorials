from fileinput import filename
from matplotlib import pyplot as plt
import numpy as np


ppFolder="../postProcessing"
quantity="eamp"
values=np.loadtxt(f'{ppFolder}/eamp_list.sh',dtype=str)
axis="X"
# file_names=['ef_0.000','ef_0.008','ef_0.013','ef_0.014','ef_0.015']
plt.title("Angle vs electric field")
data2=np.zeros((len(values),5))
# 1 in Theta M 2 Theta X
i=0
for name in values:
    data = np.loadtxt(f'{ppFolder}/{name}/strain_{axis}_angle_data.dat')
    data2[i] = data[np.where(data[:,0]==0.000)[0]]
    data2[i,0]=float(name.replace(f"{quantity}_",""))
    i=i+1
np.set_printoptions(precision=4,suppress=True,formatter={'float':lambda x: f'{x:0.3f}'})
print(f"{data2}")
plt.plot(data2[:,0],data2[:,1],label=f'$\\theta_M$ top ')
plt.plot(data2[:,0],data2[:,2],label=f'$\\theta_M$ bottom')

plt.plot(data2[:,0],data2[:,3],label=f'$\\theta_X$ top')
plt.plot(data2[:,0],data2[:,4],label=f'$\\theta_X$ bottom')

plt.grid()
plt.xlabel("Electric Field")
plt.ylabel("Angle")
plt.legend()
plt.show()
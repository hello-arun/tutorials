import numpy as np
from matplotlib import pyplot as plt

data = np.loadtxt('k.txt')

plt.plot(data[:,0],data[:,1])

plt.xticks(data[:,0])
plt.ylabel("Energy (Ry)")
plt.xlabel("K Points")
plt.title("E vs K")
plt.show()
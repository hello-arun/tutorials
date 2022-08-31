import numpy as np
import numpy.polynomial as polynomial
import matplotlib.pyplot as plt
poly=polynomial.Polynomial

data=np.loadtxt("temp.dat")
print(data)
plt.plot(data[:,0],data[:,2],".-")
pfit, stats = poly.fit(data[:,2],data[:,0],2,full=2)
target = np.array([0.0,2.0,4.0,6.0,8.0,10.0,11])
print(target)
corresponding = pfit(target)
print(corresponding)
for v in corresponding:
    print(f"{v:0.4f}")
plt.plot(corresponding,target,".-")

plt.show()
import numpy as np
import  matplotlib.pyplot as plt

def function(e, C11, C12):
    e11,e22 = e
    u = 0.5*C11*(e11**2+e22**2)+C12*(e11*e22)
    return u

ep_x = np.linspace(-6,6,7)
ep_y = np.linspace(-6,6,7)

ep_X,ep_Y = np.meshgrid(ep_x,ep_y)
toten = function((ep_X,ep_Y), 10, 2)
print("ep_X:\n",ep_X,"\n")
print("ep_Y:\n",ep_Y,"\n")
print("Toten:\n",toten,"\n")

fig = plt.figure()
fig.set_size_inches(5,5)
ax = fig.add_subplot(111, projection='3d')
ax.plot_surface(ep_X, ep_Y, toten,label="Real")
plt.savefig("./01-plot-function.png")
plt.show()
import numpy as np
import  matplotlib.pyplot as plt
import pandas as pd

data = pd.read_csv("./raw/toten.csv",skipinitialspace=True,comment="#")
data.sort_values(by=["ep_y","ep_x"],inplace=True)

ep_X = data["ep_x"].to_numpy().reshape(7,7)
ep_Y = data["ep_y"].to_numpy().reshape(7,7)
toten = data["toten"].to_numpy().reshape(7,7)

print("ep_X:\n",ep_X,"\n")
print("ep_Y:\n",ep_Y,"\n")
print("Toten:\n",toten,"\n")

fig = plt.figure()
fig.set_size_inches(5,5)
ax = fig.add_subplot(111, projection='3d')
ax.plot_surface(ep_X, ep_Y, toten,label="Real")
plt.savefig("./01-plot-function.png")
plt.show()
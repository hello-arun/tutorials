import numpy as np
import matplotlib.pyplot as plt
from matplotlib.pyplot import figure as FIG
import matplotlib.axis as AXIS
import pandas as pd

data = pd.read_csv("time-vs-setting.txt",comment="#",skipinitialspace=True,sep=",")

fig:FIG
ax:AXIS
fig,ax = plt.subplots(1,1,)
fig.set_size_inches(18.5, 10.5)


# plt.plot(data["core"],data["time"])
# plt.xlabel("Cores")
# plt.ylabel("Time (Sec)")
# plt.tight_layout(pad=0.1)
# plt.savefig("fig-time-vs-cores.svg")
# plt.show()
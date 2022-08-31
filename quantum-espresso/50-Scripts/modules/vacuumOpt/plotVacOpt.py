import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import (MultipleLocator, AutoMinorLocator)

data = np.loadtxt("../etot_vs_vac.dat")

mm=1/25.4
plt.style.use('plot_style.txt')
fig, ( ax1) = plt.subplots(1,1)
fig.set_size_inches(89*mm,75*mm)

ax1.set_xlabel(f'Vacuum size (Angstrom)')
ax1.set_ylabel(f'Energy (Ry)')

ax1.xaxis.set_major_locator(MultipleLocator(2))
ax1.xaxis.set_minor_locator(MultipleLocator(1))
# ax1.yaxis.set_major_locator(MultipleLocator(0.02))
# ax1.yaxis.set_minor_locator(MultipleLocator(0.005))

# ax1.set_xlim([-1.0,12.0])
# ax1.set_ylim([-460.8,-460.9])
ax1.plot(data[:,0],data[:,1],".-")
plt.tight_layout()
# ax1.grid()
plt.savefig("vacuumOpt.svg")
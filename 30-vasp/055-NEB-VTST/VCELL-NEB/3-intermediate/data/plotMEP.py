import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import CubicSpline,interp1d

formulaUnitsPerUnitCell = 2
data = np.loadtxt("./neb.dat",skiprows=1)
rxnCords = data[:,1]
energies = data[:,2]/formulaUnitsPerUnitCell
data_interp = np.loadtxt("./spline.dat",skiprows=1)
x_interp=data_interp[:,1]
y_interp=data_interp[:,2]/formulaUnitsPerUnitCell
EMAX = np.max(energies)
plt.plot(rxnCords,energies,"o")
plt.plot(x_interp,y_interp)
plt.title(r"$E_{b}^{forward}$ = "+f"{EMAX-energies[0]:.2f} (eV), "+r"$E_{b}^{backward}$ = "+f"{EMAX-energies[-1]:.2f} (eV)")
plt.xlabel("Reaction Cord")
plt.ylabel("Energy per formula unit (eV)")
plt.savefig("./fig1.svg")

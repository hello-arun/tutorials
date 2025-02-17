# Owner : Arun Jangir
# email : arun.jangi@kaust.edu.sa
# This script only works for inplace piezoelectric coefficients
# of 2D Materials

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from tabulate import tabulate
from matplotlib import cycler
from matplotlib.ticker import MultipleLocator, AutoMinorLocator

# Styling
pallete = cycler("color",["1f77b4", "ff7f0e", "2ca02c", "8c564b",
        "9467bd", "e377c2", "7f7f7f", "bcbd22", "17becf", "d62728",])
plt.rc("text", antialiased=True)
plt.rc("font", family="Latin Modern Roman")
plt.rc("mathtext", fontset="stix")
plt.rc("figure", titlesize=18)
plt.rc("axes", labelsize=10, prop_cycle=pallete)
plt.rc("xtick", labelsize=10, direction="in", top=True, bottom=True)
plt.rc("ytick", labelsize=10, direction="in", right=True, left=True)
plt.rc("legend", fontsize=10, title_fontsize=10, borderpad=0.2, frameon=True,
        labelspacing=0.15, columnspacing=0.00, markerscale=1, 
        handlelength=0.5, handletextpad=0.5,framealpha=0.8)


def set_limits(axes, limits):
    for i, axs in enumerate(axes):
        for j, ax in enumerate(axs):
            ax.set_xlim(limits[i][j][0:2])
            ax.set_ylim(limits[i][j][2:4])


def set_major_minors(axes, major_minors):
    for i, axs in enumerate(axes):
        for j, ax in enumerate(axs):
            ax.xaxis.set_major_locator(MultipleLocator(major_minors[i][j][0]))
            ax.xaxis.set_minor_locator(MultipleLocator(major_minors[i][j][1]))
            ax.yaxis.set_major_locator(MultipleLocator(major_minors[i][j][2]))
            ax.yaxis.set_minor_locator(MultipleLocator(major_minors[i][j][3]))


# Just replace whatever above this part to change plot stying
subplots = [1, 1]
figsize = [89/2, 82/2]  # in mm
limits = [[[-1.0, 1.0, -60, 60]]]  # axes limits [[[xmin,xmax,ymin,ymax]]]
major_minors = [[[1.0, 0.5, 20, 10]]]  # tick location [[[x_major,x_minor,y_major,y_minor]]]

mm=1/25.40
fig, axes = plt.subplots(nrows=subplots[0], ncols=subplots[1], squeeze=False)
[[ax]] = axes
fig.set_size_inches(figsize[0] * mm, figsize[1] * mm)
dfPol = pd.read_csv("./polarization.csv",skipinitialspace=True, comment="#")
dfPol=dfPol.dropna()
print(dfPol)
dfPol['strainAxis'] = dfPol['strainAxisLabel'].map({"X": 1, "Y": 2})
dfPol['polAxisLabel'] = dfPol['polAxis'].map({1:'a',2:'b'})
strainAxisLabel, polAxisLabel, polAxis, strainAxis = dfPol.iloc[0][['strainAxisLabel', 'polAxisLabel', 'polAxis', 'strainAxis']]
print("Debug", strainAxisLabel, polAxisLabel, polAxis, strainAxis)
strain = dfPol["epsilon"]
height = dfPol["c"] # Height in Angstrom
refIndex = strain.index[strain == 0][0]
pTot = dfPol["pIon"]+dfPol["pEle"]
quanta = dfPol[polAxisLabel]/dfPol["vol"]
pol3d = pTot/dfPol["vol"]
shift = dfPol["shift"]
pol3dShifted = pol3d+quanta*dfPol["shift"]

# print(f"Total 3D Polarization (e/A^2)\n{pol_3d}")
# Copnversion Factor
# e/(Ang^2) => 1.6*1E-19 columb/(Ang^2)
# e/Ang => -1.6E-19/1E-10 columb/meter => -1600 pico-columb/meter
pcoColmbMtr=-1600
pol_2d = pol3dShifted*height*pcoColmbMtr
pol_ref = pol_2d[refIndex]
pol_2d -= pol_ref

output_data = np.column_stack((strain, pTot, pol3d, quanta, shift,pol_2d))
headers = ["strain","pTot", "pol_3d(e/Ang^2)", "quanta(e/Ang^2)", "shift","pol_2d(pC/m)"]
print(tabulate(output_data, headers=headers, floatfmt=".5f"))

p1 = ax.plot(strain*100, pol_2d, "o", markersize=5,
             label="__label",mfc="none")
fit_coef = np.polyfit(strain,pol_2d,2)
slope_coef = np.array([2*fit_coef[0],fit_coef[1]])
ax.plot(strain*100, np.polyval(fit_coef,strain), "--", # label="fitted",
        color=p1[0].get_color(), mfc="none")
e22 = np.polyval(slope_coef,strain)/100.0
output_data = np.column_stack((strain*100, e22))
headers = ["strain",f"e{polAxis}{strainAxis}"]
print(tabulate(output_data, headers=headers, floatfmt=[".3f",".0f"]))

print("Slope",np.polyval(slope_coef,strain)/100.0)
correctionFactor = 0 if polAxis == strainAxis else pol_ref
message=r"$\mathrm{e_{"+f"{polAxis}{strainAxis}"+r"}}$"+f"={(correctionFactor+np.polyval(slope_coef,0))/100:.0f} ÅC/m"
print(f"# {message}")
ax.text(-0.7,-40,message)
# uncomment to give final touch
ax.set_xlabel(r"$\epsilon_{"+f"{strainAxis}{strainAxis}"+"}\ (\%)$")
ax.set_ylabel(r"$\Delta P_{"+f"{polAxis}"+"}\ \mathrm{(pC/m)}$")
set_limits(axes, limits)
set_major_minors(axes, major_minors)
ax.legend()

# fig.subplots_adjust(
#     top=0.965,
#     bottom=0.155,
#     left=0.175,
#     right=0.935,
#     hspace=0.2,
#     wspace=0.2)
fig.tight_layout(pad=0.0)
fig.savefig(f"fig-polVsStrain.svg")
plt.show()

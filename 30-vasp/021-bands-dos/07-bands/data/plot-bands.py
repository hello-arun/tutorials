# Owner : Arun Jangir
# email : arun.jangi@kaust.edu.sa

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import MultipleLocator, AutoMinorLocator
from feynman import Diagram

# Styling
def init(figsize, subplts):
    from matplotlib import cycler

    pallete = cycler(
        "color",
        [
            "475c6c",
            "ff7f0e",
            "2ca02c",
            "8c564b",
            "9467bd",
            "e377c2",
            "7f7f7f",
            "bcbd22",
            "17becf",
            "d62728",
        ],
    )
    font = {'family': 'Latin Modern Roman',"size":14}
    plt.rc("text", antialiased=True, usetex=False)
    plt.rc("font", **font)
    plt.rc("mathtext", fontset="cm")
    plt.rc("figure", titlesize=14)
    plt.rc("axes", labelsize=14, prop_cycle=pallete,titlesize=14)
    plt.rc("xtick", labelsize=14, direction="in", top=True, bottom=True)
    plt.rc("ytick", labelsize=14, direction="in", right=True, left=True)
    plt.rc(
        "legend",
        fontsize=12,
        title_fontsize=12,
        borderpad=0.2,
        frameon=True,
        labelspacing=0.15,
        columnspacing=0.00,
        markerscale=0.2,
        handlelength=0.8,
        handletextpad=0.5,
        framealpha=1.0,
    )
    mm = 1 / 25.4
    print(subplts)
    fig, (axes) = plt.subplots(subplts[0], subplts[1], squeeze=False)
    fig.set_size_inches(figsize[0] * mm, figsize[1] * mm)

    return fig, (axes)


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


def set_labels(axes, labels):
    for i, axs in enumerate(axes):
        for j, ax in enumerate(axs):
            ax.set_xlabel(labels[i][j][0])
            ax.set_ylabel(labels[i][j][1])


def set_legend(axes):
    for axs in axes:
        for ax in axs:
            ax.legend(loc="upper left")


# Just replace whatever above this part to change plot stying
subplots = [1, 1]
figsize = [85, 85]  # in mm
labels = [
    [[r"K-Path", r"E-$\mathrm{E_{VBM}}$ (eV)"]],
]  # [[[xlabel,ylabel]]]

x_tixks=np.loadtxt("KLABELS",skiprows=1,usecols=[1],comments="*")
x_tick_labels=[r"$\Gamma$",r"X",r"M",r"$\Gamma$"]

limits = [
    [[x_tixks[0], x_tixks[-1], -4, 4]],
]  # axes limits [[[xmin,xmax,ymin,ymax]]]
major_minors = [
    [[0.2, 0.1, 1, 0.5]],
]  # tick location [[[x_major,x_minor,y_major,y_minor]]]


def plot(axes,fig):
    [[ax1]] = axes
    data = np.loadtxt("BAND.dat")
    kpath=data[:,0]
    energy=data[:,1]

    vbm_pos = np.where( energy == np.max(energy[energy<0]))[0][0]
    cbm_pos = np.where( energy == np.min(energy[energy>0]))[0][0]
    
    VBM = energy[vbm_pos]
    CBM = energy[cbm_pos]
    print("Position",vbm_pos,cbm_pos)
    print("VBM,CBM: ",VBM,CBM)
    energy-=VBM
    ax1.set_xticks(x_tixks)
    ax1.set_xticklabels(x_tick_labels)
    
    ax1.axhline(y=[0],linestyle="-",color="gray",lw=0.5 )
    for x in x_tixks:
        ax1.axvline(x,ls="-",color="gray",lw=0.5)
    # ax1
    ax1.plot(
        kpath,
        energy,
    )
    # uncomment to give final touch
    set_labels(axes, labels)
    set_limits(axes, limits)
    # set_major_minors(axes, major_minors)
    # set_legend(axes)
    ax1.set_ylim(-2,2)
    ax1.text(0.74,0.35,f"{CBM-VBM:0.2f} eV")
    ax1.set_title(r"Pristine")
    # Plot the arrow
    # ax1.arrow(*start, dx, dy, head_width=arrow_length, head_length=arrow_length, fc='blue', ec='blue')
    ax1.annotate( "",xy=(kpath[cbm_pos],energy[cbm_pos]), xytext=(kpath[vbm_pos],energy[vbm_pos]),arrowprops={"arrowstyle":"<->","shrinkA":0,"shrinkB":0})#dict(arrowstyle="<->",connectionstyle="arc3"))

fig, (axes) = init(figsize, subplots)
plot(axes,fig)
fig.tight_layout(pad=0.0)
# fig.subplots_adjust(
#     top=0.99,
#     bottom=0.07,
#     left=0.065,
#     right=0.99,
#     hspace=0.155,
#     wspace=0.2)
fig.savefig("Bands.svg")
# plt.show()

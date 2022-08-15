#!/ibex/scratch/jangira/code-server/env/bin/python

# This plot template is owned by jangira@gitlab.kaust.edu.sa
# to get the latest version simply run eiither of these commands in terminal
# curl --header "PRIVATE-TOKEN: gSkpnQexiKS2h-oy1A9k" "https://gitlab.kaust.edu.sa/api/v4/projects/1614/repository/files/1-plot-general%2Fplot.py/raw?ref=master" > local_file_name.py
# wget --header "PRIVATE-TOKEN: gSkpnQexiKS2h-oy1A9k" "https://gitlab.kaust.edu.sa/api/v4/projects/1614/repository/files/1-plot-general%2Fplot.py/raw?ref=master" -O local_file_name.py

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.pyplot as plt
import pandas as pd

# Styling
def init(figsize, subplts):
    from matplotlib import cycler

    pallete = cycler(
        "color",
        [
            "1f77b4",
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
    plt.rc("font", family="STIXGeneral", size=12)
    plt.rc("mathtext", fontset="stix")
    plt.rc("figure", dpi=300, titlesize=18)
    plt.rc("axes", labelsize=12, prop_cycle=pallete)
    plt.rc("xtick", labelsize=10, direction="in", top=True, bottom=True)
    plt.rc("ytick", labelsize=10, direction="in", right=True, left=True)
    plt.rc(
        "legend",
        fontsize=8,
        title_fontsize=8,
        borderpad=0.2,
        frameon=True,
        labelspacing=0.15,
        columnspacing=0.00,
        markerscale=0.2,
        handlelength=0.8,
        handletextpad=0.5,
        framealpha=0.5,
    )

    # plt.style.use("./plot-style.mplstyle"),
    mm = 1 / 25.4
    print(subplts)
    fig, (axes) = plt.subplots(subplts[0], subplts[1], squeeze=False)
    fig.set_size_inches(figsize[0] * mm, figsize[1] * mm)
    fig.tight_layout()
    return fig, (axes)


def set_limits(axes, limits):
    for i, axs in enumerate(axes):
        for j, ax in enumerate(axs):
            ax.set_xlim(limits[i][j][0:2])
            ax.set_ylim(limits[i][j][2:4])


def set_major_minors(axes, major_minors):
    from matplotlib.ticker import MultipleLocator, AutoMinorLocator

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
            ax.legend()


GPa = 0.000101325
eV = 0.043361
ps = 0.001  # 1fs = 0.001 fs

# Just replace whatever above this part to change plot stying
figsize = [45, 45]  # in mm
subplots = [1, 1]
fig_name = "MEP.png"
labels = [[["Reaction\ncoordinate", "E(eV/unit)"]]]  # [[[xlabel,ylabel]]]
limits = [[[-0.1, 1.1, -0.1, 1.3]]]  # axes limits [[[xmin,xmax,ymin,ymax]]]

# tick location [[[x_major,x_minor,y_major,y_minor]]]
major_minors = [[[0.5, 0.1, 0.2, 0.1]]]

def plot(axes):
    ax = axes[0, 0]
    df = pd.read_csv("energy-path.csv", comment="#")
    energy_per_unit = 3*eV*(df["energy"]-df["energy"].min())/df["atoms"]
    ax.plot(df["image-no"]/df["image-no"].max(),energy_per_unit,".-",lw=0.5)
    # uncomment to give final touch
    set_labels(axes, labels)
    # set_legend(axes)
    # set_limits(axes, limits)
    # set_major_minors(axes, major_minors)


fig, (axes) = init(figsize, subplots)
plot(axes)
fig.tight_layout(pad=0.1)
plt.savefig(f"{fig_name}")
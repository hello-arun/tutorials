#!/ibex/scratch/jangira/code-server/env/bin/python

# This plot template is owned by jangira@gitlab.kaust.edu.sa
# to get the latest version simply run eiither of these commands in terminal
# curl --header "PRIVATE-TOKEN: gSkpnQexiKS2h-oy1A9k" "https://gitlab.kaust.edu.sa/api/v4/projects/1614/repository/files/1-plot-general%2Fplot.py/raw?ref=master" > local_file_name.py
# wget --header "PRIVATE-TOKEN: gSkpnQexiKS2h-oy1A9k" "https://gitlab.kaust.edu.sa/api/v4/projects/1614/repository/files/1-plot-general%2Fplot.py/raw?ref=master" -O local_file_name.py

import numpy as np
import matplotlib.pyplot as plt


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
        fontsize=10,
        title_fontsize=12,
        borderpad=0.2,
        frameon=True,
        labelspacing=0.15,
        columnspacing=0.00,
        markerscale=0.2,
        handlelength=0.8,
        handletextpad=0.5,
        framealpha=0.8,
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


# Just replace whatever above this part to change plot stying
figsize = [89*2, 89]  # in mm
subplots = [1, 2]
fig_name = "toten-vs-hp.svg"
# [[[xlabel,ylabel]]]
labels = [[["Time", "Toten/atom(eV)"],["Time", "Temp(K)"]]]
limits = [[[0, 0.30, 0, 30]]]  # axes limits [[[xmin,xmax,ymin,ymax]]]

# tick location [[[x_major,x_minor,y_major,y_minor]]]
major_minors = [[[0.05, 0.025, 5, 2.5]]]


def plot(axes):
    import pandas as pd
    eV = 0.043  # 1KCal/mol=0.043 eV
    ax1,ax2 = axes[0, 0],axes[0,1]
    data = pd.read_csv("./results/log-heating.csv",skiprows=1)
    pe=data["pe"]
    pe-=pe[0]
    ke=data["ke"]
    ke-=ke[0]
    te=pe+ke
    te-=te[0]
    atoms=data["atoms"]
    # ax1.plot(data["time"],(data["pe"]+data["ke"])/data["atoms"], label=f"TotEn")
    ax1.plot(data["time"],te/atoms, label=f"TotEn")
    ax1.plot(data["time"],pe/atoms, label=f"PE")
    ax1.plot(data["time"],ke/atoms, label=f"KE")
    ax2.plot(data["time"],data["temp"], label=f"Temp")
    ax2.plot(data["time"],data["lx"]-data["lx"][0], label=f"lx")
    ax2.plot(data["time"],data["ly"]-data["ly"][0], label=f"ly")
    # uncomment to give final touch
    set_labels(axes, labels)
    set_legend(axes)
    # set_limits(axes, limits)
    # set_major_minors(axes, major_minors)


fig, (axes) = init(figsize, subplots)
plot(axes)
fig.tight_layout()
# plt.savefig(f"{fig_name}")
plt.show()

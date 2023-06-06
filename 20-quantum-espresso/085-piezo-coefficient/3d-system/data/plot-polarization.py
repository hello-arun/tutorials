# Owner : Arun Jangir
# email : arun.jangi@kaust.edu.sa

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from tabulate import tabulate
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
    font = {
        'family': 'serif',
            'size': 12,
            # "sans-serif": "Helvetica"
            }
    plt.rc("text", antialiased=True)
    plt.rc("font", **font)
    plt.rc("mathtext", fontset="stix")
    plt.rc("figure", titlesize=18)
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
        markerscale=1,
        handlelength=2,
        handletextpad=0.5,
        framealpha=0.8,
    )
    mm = 1 / 25.4
    fig, (axes) = plt.subplots(subplts[0], subplts[1], squeeze=False)
    fig.set_size_inches(figsize[0] * mm, figsize[1] * mm)

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
subplots = [1, 1]
figsize = [89, 75]  # in mm
labels = [
    [[r"$\epsilon_{z} \%$", r"$\mathregular{\Delta\ Polarization\ (\mu C/cm^2)}$"]],
]  # [[[xlabel,ylabel]]]
limits = [
    [[-1.0, 1.0, -2.5, 2.5]]
]  # axes limits [[[xmin,xmax,ymin,ymax]]]
major_minors = [
    [[0.4, 0.2, 1, 0.5]]
]  # tick location [[[x_major,x_minor,y_major,y_minor]]]


def plot(axes):
    for axs in axes:
        for ax in axs:
            data = pd.read_csv("./polarization.csv",
                               skipinitialspace=True, comment="#")
            print(data)
            strain = data["ep_Z"]
            ref_index = strain.index[strain == 0][0]
            pol_3d = data["pol3d"]
            quanta_3d = data["quanta3d"]
            pol_3d_shifted = pol_3d+quanta_3d*data["shift"]
            uCcm2 = 100 #coulom/m^2 to micro*Columb/cm^2

            final_pol=(pol_3d_shifted-pol_3d_shifted[ref_index])*uCcm2            
            output_data = np.column_stack((strain, pol_3d, quanta_3d, data["shift"]))
            headers = ["strain", "pol_3d(C/m^2)", "quanta(C/m^2)", "shift"]
            print(tabulate(output_data, headers=headers, floatfmt=".5f"))
            
            p1=ax.plot(
                strain*100,
                final_pol,
                "o",
                label="25_SC1",
                mfc="none"
            )
            fit_coef = np.polyfit(strain,final_pol,1)
            fit_fun  = np.poly1d(fit_coef)
            ax.plot(
                strain*100,
                fit_fun(strain),
                "--",
                label="fitted",
                color=p1[0].get_color(),
                mfc="none"
            )
            message="$\mathregular{e_{33}="+f"{fit_coef[0]:0.0f}"+"\ \mu C/cm^2}$"
            print(f"# {message}")
            ax.text(-0.4,-2,message)
    # uncomment to give final touch
    set_labels(axes, labels)
    set_limits(axes, limits)
    set_major_minors(axes, major_minors)
    set_legend(axes)


fig, (axes) = init(figsize, subplots)
plot(axes)
fig.subplots_adjust(
    top=0.965,
    bottom=0.155,
    left=0.175,
    right=0.935,
    hspace=0.2,
    wspace=0.2)
fig.savefig("fig-pol-vs-strain.svg", dpi=100)
plt.show()

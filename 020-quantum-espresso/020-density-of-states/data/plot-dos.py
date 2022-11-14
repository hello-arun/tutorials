# Owner : Arun Jangir
# email : arun.jangi@kaust.edu.sa

from email.policy import default
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
    font = {'family': 'sans-serif',
            'size': 12,
            "sans-serif": "Helvetica"
            }
    plt.rc("text", antialiased=True)
    plt.rc("font", **font)
    plt.rc("mathtext", fontset="cm")
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
        markerscale=0.2,
        handlelength=0.8,
        handletextpad=0.5,
        framealpha=0.8,
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
figsize = [85, 85]  # in mm
labels = [
    [["Eenergy (eV)", "DOS"]],
]  # [[[xlabel,ylabel]]]
limits = [
    [[-5, 5, -0.005, 2.5]],
]  # axes limits [[[xmin,xmax,ymin,ymax]]]
major_minors = [
    [[2, 1, 2, 1]],
]  # tick location [[[x_major,x_minor,y_major,y_minor]]]


def plot(axes):
    [[ax1]] = axes
    dos_file = "dos.dat"
    with open(dos_file) as f:
        first_line = f.readline()

    data = np.loadtxt(dos_file)
    energy = data[:, 0]
    dos = data[:, 1]
    e_fermi = float(first_line.split()[-2])
    ax1.plot(
        energy-e_fermi,
        dos,
        label="Si-DOS",
    )
    ax1.plot(
        [0, 0],
        [0, 100],
        "--"
        # label="Si-DOS",
    )
    # uncomment to give final touch
    set_labels(axes, labels)
    set_limits(axes, limits)
    # set_major_minors(axes, major_minors)
    set_legend(axes)


fig, (axes) = init(figsize, subplots)
plot(axes)
fig.subplots_adjust(
    top=0.97,
    bottom=0.13,
    left=0.145,
    right=0.99,
    hspace=0.155,
    wspace=0.2)
fig.savefig("dos-silicon.png", dpi=100)
plt.show()

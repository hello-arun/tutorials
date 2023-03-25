# Owner : Arun Jangir
# email : arun.jangi@kaust.edu.sa

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
            ax.legend(loc="upper left")


# Just replace whatever above this part to change plot stying
subplots = [3, 1]
figsize = [89, 1.4*89]  # in mm
fig_name = "010-common-axis-plot.png"
labels = [
    [[r"$\theta^\circ$", r"$\tan(\theta)$"]],
    [[r"$\theta^\circ$", r"$\cos(\theta)$"]],
    [[r"$\theta^\circ$", r"$\sin(\theta)$"]],
]  # [[[xlabel,ylabel]]]
limits = [
    [[0, 360, -1.2, 1.2]],
    [[0, 360, -1.2, 1.2]],
    [[0, 360, -1.2, 1.2]],
]  # axes limits [[[xmin,xmax,ymin,ymax]]]
major_minors = [
    [[45, 15, 0.5, 0.1]],
    [[45, 15, 0.5, 0.1]],
    [[45, 15, 0.5, 0.1]],
]  # tick location [[[x_major,x_minor,y_major,y_minor]]]


def plot(axes):
    ax_tan, ax_cos, ax_sin = axes[0, 0], axes[1, 0], axes[2, 0]
    x = np.arange(361)
    rad = np.pi/180.0
    ax_sin.plot(x, np.sin(x*rad), label=r"$\sin(\theta)$")
    ax_cos.plot(x, np.cos(x*rad), label=r"$\cos(\theta)$")
    ax_tan.plot(x, np.tan(x*rad), label=r"$\tan(\theta)$")

    # uncomment to give final touch
    set_labels(axes, labels)
    set_limits(axes, limits)
    set_major_minors(axes, major_minors)
    set_legend(axes)

    # Share axes
    ax_sin.sharex(ax_cos)   # sin share axis with cos
    ax_cos.sharex(ax_tan)   # cos share axis with tan
    # Turn off x-axis label
    ax_tan.set_xlabel("")
    ax_cos.set_xlabel("")
    # Turn off x-axis tick-labels
    ax_tan.xaxis.set_ticklabels([])
    ax_cos.xaxis.set_ticklabels([])


fig, (axes) = init(figsize, subplots)
plot(axes)
fig.subplots_adjust(
    top=0.995,
    bottom=0.08,
    left=0.175,
    right=0.965,
    hspace=0.0,
    wspace=0.2)

fig.savefig(f"{fig_name}",dpi=150)
plt.show()

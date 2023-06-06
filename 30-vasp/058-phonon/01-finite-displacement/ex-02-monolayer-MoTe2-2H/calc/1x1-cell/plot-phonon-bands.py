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


def read_band_yaml(filename):
    # References
    #   https://github.com/raymond-yiqunwang/phonon_bandplot
    #   https://github.com/phonopy/phonopy/blob/develop/scripts/phonopy-bandplot#L176-L221
    #   https://github.com/phonopy/phonopy/blob/4512189b74978edcd25e8ef1977f7c31f99a06b4/scripts/phonopy-bandplot#L176-L221
    
    import yaml
    from yaml import CLoader as Loader
    with open(filename) as f:
        data = yaml.load(f,Loader=Loader)

    frequencies = []
    distances = []
    hslabels = [] # high-symmetry labels
    hspoint_idx = [0,] # High symmetry points
    for j, v in enumerate(data["phonon"]):
        if "label" in v:
            hslabels.append(v["label"])
        else:
            hslabels.append(None)
        frequencies.append([f["frequency"] for f in v["band"]])
        # qpoints.append(v["q-position"])
        distances.append(v["distance"])

    if "labels" in data:
        hslabels = data["labels"]
    elif all(x is None for x in hslabels):
        hslabels = []

    hspoint_idx = [0,]
    lbls = [hslabels[0][0]]
    for i,nq in enumerate(data["segment_nqpoint"]):
        hspoint_idx.append(nq + hspoint_idx[-1])
        lbls.append(hslabels[i][1])
    hspoint_idx[-1] -= 1
    hslabels=lbls
    return (
        np.array(distances),
        np.array(frequencies),
        hslabels,
        hspoint_idx
    )

# Just replace whatever above this part to change plot stying
(distances,freqs,hslabels,hspoint_idx)=read_band_yaml("./band.yaml")
subplots = [1, 1]
figsize = [90, 90]  # in mm
labels = [[["",r"Frequency ($cm^{-1}$)"]]]  # [[[xlabel,ylabel]]]
limits = [[[distances[0], distances[-1], 0, 340]]]  # axes limits [[[xmin,xmax,ymin,ymax]]]
major_minors = [[[2, 1, 2, 1]]]  # tick location [[[x_major,x_minor,y_major,y_minor]]]


def plot(axes):
    [[ax]]=axes
    ax.plot(distances,freqs,"b-")
    ax.set_xticks(distances[hspoint_idx],hslabels)
    # uncomment to give final touch
    set_labels(axes, labels)
    set_limits(axes, limits)
    # set_major_minors(axes, major_minors)
    # set_legend(axes)


fig, (axes) = init(figsize, subplots)
plot(axes)
fig.subplots_adjust(
top=0.949,
bottom=0.104,
left=0.217,
right=0.935,
hspace=0.2,
wspace=0.2)
fig.savefig("band.svg")
plt.show()
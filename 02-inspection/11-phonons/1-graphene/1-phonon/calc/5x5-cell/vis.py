#!/usr/bin/env python3
"""
Interactive phonon band structure viewer + mode animator.

Click any point on the phonon band structure and watch the atoms move
in that vibrational mode.

Requirements
------------
    pip install phonopy ase matplotlib numpy

Inputs required (from your original Phonopy/VASP run)
-------------------------------------------------------
    POSCAR                 - primitive/unit cell used for the phonon calc
    FORCE_SETS  (or)
    FORCE_CONSTANTS        - whichever you used to build the band structure

Edit the CONFIG block below to match your setup, then run:

    python phonon_mode_animator.py

Notes
-----
- Frequencies are computed internally in THz (Phonopy's default) and
  converted to cm^-1 only for the plot labels/click-matching, to match
  the axis in your VASP/Phonopy band.conf plot.
- For q != Gamma, the script builds the smallest supercell that is
  commensurate with q (by rationalizing each fractional component),
  so you can actually see the periodic wave pattern of that mode.
"""

import numpy as np
from fractions import Fraction
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D  # noqa: F401
from matplotlib.animation import FuncAnimation

from phonopy import Phonopy
from phonopy.interface.calculator import read_crystal_structure

# ----------------------------------------------------------------------
# CONFIG - edit these paths / settings for your system
# ----------------------------------------------------------------------
POSCAR_FILE = "POSCAR"
FORCE_SETS_FILE = "FORCE_SETS"          # set to None if using FORCE_CONSTANTS
FORCE_CONSTANTS_FILE = ""             # e.g. "FORCE_CONSTANTS"

SUPERCELL_MATRIX = [[5, 0, 0], [0, 5, 0], [0, 0, 1]]   # the one used in your phonon calc
PRIMITIVE_MATRIX = "auto"                               # or an explicit 3x3 matrix

THZ_TO_CM1 = 33.35641

# Graphene high-symmetry path in reduced (reciprocal, primitive) coordinates
LABELS = ["G", "K", "M", "G"]
QPOINTS = [
    [0.0, 0.0, 0.0],
    [1 / 3, 1 / 3, 0.0],
    [0.5, 0.0, 0.0],
    [0.0, 0.0, 0.0],
]
NPOINTS_PER_SEGMENT = 51

MAX_DENOMINATOR = 12       # for finding a commensurate supercell for q != Gamma
ANIM_AMPLITUDE = 0.6       # Angstrom-scale visual amplitude (exaggerated, not physical)
ANIM_FRAMES = 60
ANIM_INTERVAL_MS = 40

# ----------------------------------------------------------------------
# 1. Build the Phonopy object and compute the band structure with
#    eigenvectors at every q-point on the path
# ----------------------------------------------------------------------

def build_phonopy():
    unitcell, _ = read_crystal_structure(POSCAR_FILE, interface_mode="vasp")
    phonon = Phonopy(
        unitcell,
        supercell_matrix=SUPERCELL_MATRIX,
        primitive_matrix=PRIMITIVE_MATRIX,
    )

    if FORCE_CONSTANTS_FILE:
        from phonopy.file_IO import parse_FORCE_CONSTANTS
        fc = parse_FORCE_CONSTANTS(FORCE_CONSTANTS_FILE)
        phonon.force_constants = fc
    else:
        from phonopy.file_IO import parse_FORCE_SETS
        force_sets = parse_FORCE_SETS(filename=FORCE_SETS_FILE)
        phonon.dataset = force_sets
        phonon.produce_force_constants()

    return phonon


def compute_bands(phonon):
    paths = []
    for i in range(len(QPOINTS) - 1):
        q0 = np.array(QPOINTS[i])
        q1 = np.array(QPOINTS[i + 1])
        seg = [q0 + (q1 - q0) * t for t in np.linspace(0, 1, NPOINTS_PER_SEGMENT)]
        paths.append(seg)

    phonon.run_band_structure(paths, with_eigenvectors=True, is_band_connection=False)
    bs = phonon.get_band_structure_dict()
    # bs['qpoints']:      list over segments of arrays (npoints, 3)
    # bs['distances']:    list over segments of arrays (npoints,)
    # bs['frequencies']:  list over segments of arrays (npoints, nbands)  [THz]
    # bs['eigenvectors']: list over segments of arrays (npoints, nbands, nbands) complex
    return bs


# ----------------------------------------------------------------------
# 2. Flatten the band structure into simple arrays for plotting/picking
# ----------------------------------------------------------------------

def flatten_bands(bs):
    all_q, all_d, all_f, all_v = [], [], [], []
    seg_boundaries = [0.0]
    offset = 0.0
    for seg_i in range(len(bs["distances"])):
        d = np.array(bs["distances"][seg_i]) + offset
        all_q.append(np.array(bs["qpoints"][seg_i]))
        all_d.append(d)
        all_f.append(np.array(bs["frequencies"][seg_i]))   # THz
        all_v.append(np.array(bs["eigenvectors"][seg_i]))  # complex
        # offset = d[-1]
        seg_boundaries.append(offset)

    q = np.concatenate(all_q, axis=0)
    d = np.concatenate(all_d, axis=0)
    f = np.concatenate(all_f, axis=0)          # (npts, nbands) THz
    v = np.concatenate(all_v, axis=0)          # (npts, nbands, nbands)
    return q, d, f, v, seg_boundaries


# ----------------------------------------------------------------------
# 3. Build a commensurate supercell for a given q and displace atoms
# ----------------------------------------------------------------------

def commensurate_repeats(q, max_den=MAX_DENOMINATOR):
    reps = []
    for comp in q:
        frac = Fraction(comp).limit_denominator(max_den)
        n = frac.denominator if abs(frac) > 1e-6 else 1
        reps.append(max(n, 1))
    return reps


def build_mode_trajectory(phonon:Phonopy, q, eigvec, freq_thz, n_frames=ANIM_FRAMES,
                           amplitude=ANIM_AMPLITUDE):
    primitive = phonon.primitive
    pos_frac = primitive.scaled_positions
    lattice = primitive.cell
    masses = primitive.masses
    n_atoms = len(masses)

    nx, ny, nz = commensurate_repeats(q)
    nx, ny, nz = max(nx, 1), max(ny, 1), max(nz, 1)

    # eigvec is a flat vector of length 3*n_atoms; reshape to (n_atoms, 3)
    e = np.array(eigvec).reshape(n_atoms, 3)

    equilibrium = []
    cell_index = []
    for ix in range(nx):
        for iy in range(ny):
            for iz in range(nz):
                shift_frac = np.array([ix, iy, iz])
                for j in range(n_atoms):
                    cart = (pos_frac[j] + shift_frac) @ lattice
                    equilibrium.append(cart)
                    cell_index.append((ix, iy, iz, j))
    equilibrium = np.array(equilibrium)

    omega = 2 * np.pi * freq_thz  # rad / ps
    period_ps = 1.0 / freq_thz if freq_thz > 1e-3 else 1.0
    times = np.linspace(0, period_ps, n_frames, endpoint=False)

    trajectory = np.zeros((n_frames, len(equilibrium), 3))
    for t_i, t in enumerate(times):
        for idx, (ix, iy, iz, j) in enumerate(cell_index):
            phase = 2 * np.pi * (q[0] * ix + q[1] * iy + q[2] * iz)
            disp = (e[j] / np.sqrt(masses[j])) * np.exp(1j * (phase - omega * t))
            trajectory[t_i, idx] = equilibrium[idx] + amplitude * np.real(disp)

    elements = [primitive.symbols[j] for (_, _, _, j) in cell_index]
    return trajectory, elements, equilibrium


def nearest_neighbor_bonds(equilibrium, cutoff_scale=1.3):
    from scipy.spatial import cKDTree
    tree = cKDTree(equilibrium)
    dists, idxs = tree.query(equilibrium, k=2)
    typical_bond = np.median(dists[:, 1])
    cutoff = typical_bond * cutoff_scale
    pairs = tree.query_pairs(r=cutoff)
    return list(pairs)


def q_to_cartesian(lattice, q):
    """Convert fractional reciprocal-space q to Cartesian (1/Angstrom).
 
    lattice rows are real-space vectors a_i. Reciprocal vectors b_i satisfy
    a_i . b_j = 2*pi*delta_ij, so q_cartesian = q_frac @ reciprocal_lattice.
    """
    reciprocal_lattice = 2 * np.pi * np.linalg.inv(lattice).T  # rows = b_i
    return np.array(q) @ reciprocal_lattice
 
 
def build_wave_grid(equilibrium, q_cart, pad=2.5, resolution=220):
    """Grid over the sheet extent for the phase texture cos(q.r - w t)."""
    x_min, x_max = equilibrium[:, 0].min() - pad, equilibrium[:, 0].max() + pad
    y_min, y_max = equilibrium[:, 1].min() - pad, equilibrium[:, 1].max() + pad
    xs = np.linspace(x_min, x_max, resolution)
    ys = np.linspace(y_min, y_max, resolution)
    X, Y = np.meshgrid(xs, ys)
    # in-plane phase; q_cart[2] is ~0 for graphene's Gamma-K-M-Gamma path
    base_phase = q_cart[0] * X + q_cart[1] * Y
    extent = (x_min, x_max, y_min, y_max)
    return base_phase, extent
 
# ----------------------------------------------------------------------
# 4. Interactive plot: click a point -> animate that mode
# ----------------------------------------------------------------------

class BandClickAnimator:
    def __init__(self, d, f_cm1, phonon, q_all, eigvec_all, freq_all_thz):
        self.d = d
        self.f_cm1 = f_cm1
        self.phonon = phonon
        self.q_all = q_all
        self.eigvec_all = eigvec_all
        self.freq_all_thz = freq_all_thz
        self.anim = None

        self.fig_band, self.ax_band = plt.subplots(figsize=(7, 5))
        for b in range(f_cm1.shape[1]):
            self.ax_band.plot(d, f_cm1[:, b], "r-", linewidth=1.2, picker=5)
        self.ax_band.set_ylabel("Frequency (cm$^{-1}$)")
        self.ax_band.set_title("Click a point on a band to animate that mode")
        self.fig_band.canvas.mpl_connect("button_press_event", self.on_click)

    def on_click(self, event):
        if event.inaxes != self.ax_band or event.xdata is None or event.ydata is None:
            return
        # nearest (q-index, band-index) to the click
        dd = np.abs(self.d - event.xdata)
        q_idx = int(np.argmin(dd))
        band_idx = int(np.argmin(np.abs(self.f_cm1[q_idx] - event.ydata)))

        q = self.q_all[q_idx]
        freq_thz = self.freq_all_thz[q_idx, band_idx]
        if freq_thz <= 1e-3:
            print("Selected an acoustic mode at/near Gamma (~0 frequency) - skipping.")
            return
        eigvec = self.eigvec_all[q_idx][:, band_idx]

        print(f"Selected q = {np.round(q, 4)}, band {band_idx}, "
              f"freq = {freq_thz * THZ_TO_CM1:.1f} cm^-1")

        self.animate_mode(q, eigvec, freq_thz)

        eigvec = self.eigvec_all[q_idx][:, band_idx]
 
        print(f"Selected q = {np.round(q, 4)}, band {band_idx}, "
              f"freq = {freq_thz * THZ_TO_CM1:.1f} cm^-1")
 
        self.animate_mode(q, eigvec, freq_thz)
 
    def animate_mode(self, q, eigvec, freq_thz):
        traj, elements, equilibrium = build_mode_trajectory(
            self.phonon, q, eigvec, freq_thz
        )
        bonds = nearest_neighbor_bonds(equilibrium)
 
        lattice = self.phonon.primitive.cell
        q_cart = q_to_cartesian(lattice, q)
        base_phase, extent = build_wave_grid(equilibrium, q_cart)
        omega = 2 * np.pi * freq_thz
        n_frames = traj.shape[0]
        period_ps = 1.0 / freq_thz
        times = np.linspace(0, period_ps, n_frames, endpoint=False)
 
        # z-displacement (out-of-plane motion, relevant for ZA/ZO branches)
        # is encoded as marker color on the 2D top-down view.
        z_disp = traj[:, :, 2] - equilibrium[:, 2]
        z_scale = max(np.abs(z_disp).max(), 1e-6)
 
        fig, ax = plt.subplots(figsize=(6.5, 6.5))
        wave_img = ax.imshow(
            np.cos(base_phase), extent=extent, origin="lower",
            cmap="RdBu_r", vmin=-1, vmax=1, alpha=0.35, zorder=0,
        )
 
        bond_lines = [
            ax.plot([], [], color="gray", linewidth=1.3, zorder=1)[0]
            for _ in bonds
        ]
        pts = ax.scatter(
            traj[0, :, 0], traj[0, :, 1],
            c=z_disp[0], cmap="coolwarm", vmin=-z_scale, vmax=z_scale,
            s=140, edgecolors="black", linewidths=0.6, zorder=2,
        )
        cbar = fig.colorbar(pts, ax=ax, shrink=0.7, pad=0.02)
        cbar.set_label("Out-of-plane displacement (Å)")
 
        ax.set_xlim(*extent[:2])
        ax.set_ylim(*extent[2:])
        ax.set_aspect("equal")
        ax.set_xlabel("x (Å)")
        ax.set_ylabel("y (Å)")
        ax.set_title(
            f"q={np.round(q, 3)}   f={freq_thz * THZ_TO_CM1:.1f} cm$^{{-1}}$\n"
            "background: propagating phase cos(q\u00b7r \u2212 \u03c9t)"
        )
 
        def update(frame):
            xy = traj[frame, :, :2]
            pts.set_offsets(xy)
            pts.set_array(z_disp[frame])
            for line, (i, j) in zip(bond_lines, bonds):
                line.set_data([xy[i, 0], xy[j, 0]], [xy[i, 1], xy[j, 1]])
        self.anim = FuncAnimation(
            fig, update, frames=n_frames,
            interval=ANIM_INTERVAL_MS, blit=False, repeat=True,
        )
        plt.show()
 


def main():
    phonon = build_phonopy()
    bs = compute_bands(phonon)
    q_all, d, f_thz, v_all, seg_bounds = flatten_bands(bs)

    f_cm1 = f_thz * THZ_TO_CM1

    label_positions = seg_bounds
    animator = BandClickAnimator(d, f_cm1, phonon, q_all, v_all, f_thz)
    animator.ax_band.set_xticks(label_positions)
    animator.ax_band.set_xticklabels([r"$\Gamma$" if l == "G" else l for l in LABELS])
    animator.ax_band.set_xlim(d[0], d[-1])
    for x in label_positions[1:-1]:
        animator.ax_band.axvline(x, color="gray", linewidth=0.5)
    plt.show()


if __name__ == "__main__":
    main()
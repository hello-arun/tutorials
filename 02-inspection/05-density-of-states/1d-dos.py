import matplotlib.pyplot as plt
import numpy as np

# 1. Define grid size and bin width
maxN = 1000
dE   = 10000  # Increased dE to smoothly group the larger energy values

# 2. Vectorized grid generation
nxs = np.arange(1, maxN)
energies = nxs**2

# 3. Optimize counting using np.histogram (replaces the loop)
max_energy = maxN**2
bins = np.arange(0, max_energy + dE, dE)

# This counts how many states fall into each energy bin automatically
dos_counts, bin_edges = np.histogram(energies, bins=bins)

# 4. Plot the Density of States against Energy
# We use the left edge of each bin as the x-axis coordinate
plt.figure(figsize=(8, 5))
plt.plot(bin_edges[:-1], dos_counts, ".-",color='darkorange', lw=2)

energy_mids = bin_edges[:-1] + dE / 2
log_E = np.log(energy_mids)
log_dos = np.log(dos_counts)
slope, intercept = np.polyfit(log_E, log_dos, 1)

print(f"The numerically determined order (exponent) is: {slope:.3f}")

plt.xlabel('Energy (E)')
plt.ylabel('Number of States (g(E))')
plt.title('Numerical 2D Density of States (Flat Line)')
plt.grid(True, linestyle='--')
plt.xlim(0, max_energy)
plt.ylim(0, np.max(dos_counts) * 1.2) # Give some headroom
plt.show()
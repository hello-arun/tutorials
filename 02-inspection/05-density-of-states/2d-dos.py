import matplotlib.pyplot as plt
import numpy as np

# 1. Define a smaller grid size for 3D (to save memory) and bin width
maxN = 1000
dE = 1000

# 2. Vectorized 3D grid generation
n = np.arange(1, maxN)
nxs, nys = np.meshgrid(n, n, indexing='ij')
energies = nxs**2 + nys**2 

# 3. Count states using np.histogram
max_energy = maxN**2
bins = np.arange(0, max_energy + dE, dE)
dos_counts, bin_edges = np.histogram(energies, bins=bins)

# Get the midpoints of the energy bins for fitting
energy_mids = bin_edges[:-1] + dE / 2

# 4. Fit a power-law relationship: g(E) = A * E^power
# We can do a linear fit in log-log space: log(g(E)) = log(A) + power * log(E)
# Filter out zeros to avoid log errors
valid = (energy_mids > 0) & (dos_counts > 0)
log_E = np.log(energy_mids[valid])
log_dos = np.log(dos_counts[valid])

# Fit a 1st-degree polynomial (a straight line) to the log-log data
slope, intercept = np.polyfit(log_E, log_dos, 1)

print(f"The numerically determined order (exponent) is: {slope:.3f}")

# 5. Plot the numerical data and the polynomial fit
# plt.figure(figsize=(8, 5))
plt.scatter(energy_mids, dos_counts, color='teal', alpha=0.5, label='Numerical Data (2D)')
plt.plot(energy_mids, np.exp(intercept) * (energy_mids**slope), color='crimson', lw=2, 
         label=f'Polynomial Fit ($E^{{{slope:.2f}}}$)')

plt.xlabel('Energy (E)')
plt.ylabel('Number of States (g(E))')
plt.title('Numerical 2D Density of States and Polynomial Fit')
plt.legend()
plt.ylim(bottom=0)  # Ensure y-axis starts at 0
# plt.grid(True, linestyle='--')
plt.show()
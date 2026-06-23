import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib.widgets import Slider

# --- Simulation Parameters ---
N = 40          # Grid size (15x15 to make arrows readable)
T_init = 2.27   # Initial Temperature
J = 1.0         # Interaction strength
steps_per_frame = 200 # Change this to control the speed of the simulation

# --- Initialize the Grid ---
grid = np.random.choice([1, -1], size=(N, N))

def metropolis_step(grid, T):
    """Performs Monte Carlo steps using the Metropolis algorithm."""
    N = grid.shape[0]
    for _ in range(steps_per_frame):
        x = np.random.randint(0, N)
        y = np.random.randint(0, N)
        spin = grid[x, y]
        
        neighbor_spin_sum = (grid[(x + 1) % N, y] + 
                     grid[(x - 1) % N, y] + 
                     grid[x, (y + 1) % N] + 
                     grid[x, (y - 1) % N])
        
        dE = 2 * J * spin * neighbor_spin_sum
        if dE <= 0 or np.random.rand() < np.exp(-dE / T):
            grid[x, y] = -spin

# --- Visualization Setup ---
fig, ax = plt.subplots(figsize=(6, 7))
plt.subplots_adjust(bottom=0.2)  # Make room for the slider

# Create coordinate matrices for the arrows
X, Y = np.meshgrid(np.arange(N), np.arange(N))
U = np.zeros_like(grid)  # Arrows only point up or down, so X-component is 0

# Function to determine arrow colors based on spins
def get_colors(g):
    return np.where(g == 1, 'blue', 'red').flatten()

# Initialize the arrow plot (Quiver)
# V represents the Y-component (spin direction)
qv = ax.quiver(X, Y, U, grid, color=get_colors(grid), 
               scale=N*1.2, pivot='mid', headwidth=4, headlength=5)

ax.set_title(f"2D Ising Model")
ax.set_xlim(-1, N)
ax.set_ylim(-1, N)
ax.axis('off')

# --- Add Temperature Slider ---
ax_slider = plt.axes([0.2, 0.05, 0.6, 0.03])
slider_T = Slider(ax_slider, 'Temp (T)', 0.1, 5.0, valinit=T_init, valfmt='%1.2f')

# --- Animation Loop ---
def update(frame):
    current_T = slider_T.val  # Read the live temperature from the slider
    metropolis_step(grid, current_T)
    
    # Update arrow directions and colors
    qv.set_UVC(U, grid)
    qv.set_color(get_colors(grid))
    return qv,

ani = animation.FuncAnimation(fig, update, frames=200, interval=50, blit=False)
plt.show()
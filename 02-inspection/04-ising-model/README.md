The Ising mode in statistical physics takes a hopelessly complex system and strips it down to its absolute bare minimum components. It was originally created to understand ferromagnetism (how materials become permanent magnets). It models a material as a grid or lattice of sites. Each site contains a microscopic magnetic "spin" that can only point in one of two directions: Up ($+1$) or Down ($-1$).

**Operates on a simple rule**: neighboring spins want to point in the same direction to lower their energy. However, thermal energy (temperature) tries to shake them up and randomize.

The logic of the program breaks down into a few core steps:
1. 🏁 **Initialize the Grid**: Create a 2D array representing the iron sheet, randomly filled with $+1$ (Up) and $-1$ (Down) to represent a high-temperature state.

2. 🎲 **Pick a Random Spin**: Choose a random site on the grid. Calculate the Energy Change ($\Delta E$): Compute how the total energy would change if you flipped that single spin. This depends only on the four immediate neighbors (up, down, left, right).

3. ⚖️ **Accept or Reject the Flip**: If flipping the spin lowers the energy ($\Delta E \le 0$), accept the flip.If flipping raises the energy ($\Delta E > 0$), accept it only by a random chance based on the temperature, calculated using the Boltzmann factor: $P = e^{-\Delta E / (k_B T)}$.

4. 🔁 **Loop**: Repeat this process millions of times to let the system reach equilibrium.

### Calculating $\Delta \mathbf{E}$:

Let $s_0$ be the initial spin and $s_1 = -s_0$ be the flipped spin. The change in energy $\Delta E$ depends only on the sum over the nearest neighboring sites $n$:

$$\Delta E = E_{\text{final}} - E_{\text{initial}}$$

$$\Delta E = -\sum_{n} J s_1 s_n - \left( -\sum_{n} J s_0 s_n \right)$$

Factoring out the shared terms and substituting $s_1 = -s_0$:

$$\Delta E = -J (s_1 - s_0) \sum_{n} s_n$$

$$\Delta E = 2 J s_0 \sum_{n} s_n$$
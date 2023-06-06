import pandas as pd
import matplotlib.pyplot as plt

data = pd.read_csv("en-vs-grid.csv", comment="#", skipinitialspace=True)

plt.plot(data["grid"], data["enPerAtom"])
plt.xlabel("grid")
plt.ylabel("Energy (eV/Atom)")
plt.savefig("en-vs-grid.png")

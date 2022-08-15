The [pair-correlation function](https://en.wikipedia.org/wiki/Radial_distribution_function) is written to the [PCDAT](https://www.vasp.at/wiki/index.php/PCDAT) file. It can be visualized using **pair_correlation.sh**. 

In [ex-01-Si-melting](../../ex-01-Si-melting-090fs/), you already simulated 90fs, so copy that [PCDAT](https://www.vasp.at/wiki/index.php/PCDAT) file to **PCDAT.090fs**! In [ex-02-Si-melting](../../ex-02-Si-melting-180fs/) we restarted from the final structure of [ex-01](../../ex-01-Si-melting-090fs/). Therefore, that [PCDAT](https://www.vasp.at/wiki/index.php/PCDAT) file corresponds to melting silicon after a total time of 180fs, but taking the ensemble average only over the simulation time of 90fs set by [NSW](https://www.vasp.at/wiki/index.php/NSW) and [POTIM](https://www.vasp.at/wiki/index.php/POTIM). Copy the [PCDAT](https://www.vasp.at/wiki/index.php/PCDAT) file to **PCDAT.180fs**! Then, plot the result and compare the pair-correlation functions!

Enter the following into the terminal:

```bash
bash grep-PCDAT.sh
bash pair-correlation.sh .090fs
bash pair-correlation.sh .180fs
gnuplot pair-correlation.gp
```
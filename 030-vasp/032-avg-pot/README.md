## Why Average-Potential
* Average potential is helpful in finding out if we need to use dipole correction or not.
* If the dipole correction is incorporated, it tells if correctly implemented or not.

## How to do
The total potential is expressed as 
$$V_{\mathrm{LOCPOT}}(\textbf{r}) = V(\textbf{r})+\int{\frac{n(\textbf{r'})}{|\textbf{r}-\textbf{r'}|}d\textbf{r'}}+V_{\mathrm{XC}}(\textbf{r})$$
where $V(\textbf{r})$ is the ionic potential, the second term is the Hartree potential and $V_{\mathrm{XC}}(\textbf{r})$ is the exchange-correlation potential.

This potential is written to `LOCPOT` file. You can control weather the $V_{\mathrm{XC}}$ should be included in the `LOCPOT` file or not.

|Tag|Behavior|
|:--:|:--|
|`LVTOT=.TRUE.`| All three terms are written to LOCPOT|
|`LVHAR=.TRUE.`|LOCPOT file is written without $V_{\mathrm{XC}}$|

For Average Potential Analysis `LVHAR=.TRUE.` is better choice.

## Post Processing
You need to use `vaspkit` to post process the `LOCPOT` file. You can use
```bash
module load vaspkit
vaspkit
# Then Choose Option 42 -> 426 -> 3(For average along z-dir)
```
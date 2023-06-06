#!/bin/bash
grep "volume of cell" OUTCAR | head -1 | tee polarization.csv
grep "p\[elc\]" OUTCAR | tee -a polarization.csv
grep "p\[ion\]" OUTCAR | tee -a polarization.csv
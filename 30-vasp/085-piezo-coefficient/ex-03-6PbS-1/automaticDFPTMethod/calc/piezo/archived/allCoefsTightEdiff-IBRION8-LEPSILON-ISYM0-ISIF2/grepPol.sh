#!/bin/bash
grep "PIEZOELECTRIC TENSOR" OUTCAR -A5 | tail -n13 > polarization.csv


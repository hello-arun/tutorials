#!/bin/bash

k_mesh_file="k-mesh.csv"
res_lat_file="res-lat.csv"
grep "reciprocal lattice vectors" -A3 -m1 ./OUTCAR | awk '{print $4,$5,$6}' > $res_lat_file

# column -t $k_mesh_file > ./temp
# mv temp $k_mesh_file
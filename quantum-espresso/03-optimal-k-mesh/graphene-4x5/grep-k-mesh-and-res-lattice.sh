#!/bin/bash

k_mesh_file="k-mesh.csv"
res_lat_file="res-lat.csv"
grep " k(  " ./OUTCAR-scf.pw | awk '{print $5,$6,$7}'| sed "s/),//" > $k_mesh_file
grep " b(" ./OUTCAR-scf.pw | awk '{print $4,$5,$6}' > $res_lat_file

# column -t $k_mesh_file > ./temp
# mv temp $k_mesh_file
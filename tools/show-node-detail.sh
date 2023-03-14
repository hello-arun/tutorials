#!/bin/bash

# Author: Arun Jangir (Arun.Jangir@kaust.edu.sa)
# 
# Script file to display active features of nodes used in 
# calculation. It will read the node name for std.out
# --------------------------------------- 
#       bash show-node-detail.sh std.out
# ---------------------------------------

nodeList=$(grep "NodeList" $1 | awk '{print $2}')
nodeList=$(echo ${nodeList//,/ })
echo "Node List: $nodeList"
for node in $nodeList; do
    activeFeatures=$(scontrol show node $node| grep "ActiveFeatures")
    echo "$node => $activeFeatures"
done
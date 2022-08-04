#!/bin/bash
NETWORK_PSEUDO=https://pseudopotentials.quantum-espresso.org/upf_files/
PSEUDO_LIST="Pb.pz-d-van.UPF Ti.pz-sp-van_ak.UPF O.pz-van_ak.UPF"
for FILE in $PSEUDO_LIST ; do
    if test ! -r $PSEUDO_DIR/$FILE ; then
       echo "Downloading $FILE"
       curl -O ${NETWORK_PSEUDO}/$FILE 2> /dev/null
    fi
done
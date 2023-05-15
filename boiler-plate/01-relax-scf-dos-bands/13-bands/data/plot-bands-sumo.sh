sumo-bandplot \
    --ymin -4 \
    --ymax  4 \
    --format svg \
    --zero-line  \
    --band-edges \
    --style "./matplotlib.rc" 
    # --circle-size 30 \
    # --project Sn.s,Sn.p,Se.s,Se.p
    # --mode line \
    # --dos ../../../06-dos/calc/gm-grid-15x15x1-slab-middle-ISMEAR_-5/vasprun.xml \
    # --font "Latin Modern Roman" \
mv band.svg band-sumo.svg
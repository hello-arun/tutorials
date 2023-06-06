sumo-bandplot \
    --ymin -2 \
    --ymax  2 \
    --format svg \
    --zero-line  \
    --style "./matlotlib.rc" \
    --mode stacked \
    --circle-size 30 \
    --project Sn.s,Sn.p,Se.s,Se.p,Se.d
    # --dos ../../../06-dos/calc/gm-grid-15x15x1-slab-middle-ISMEAR_-5/vasprun.xml \
    # --font "Latin Modern Roman" \
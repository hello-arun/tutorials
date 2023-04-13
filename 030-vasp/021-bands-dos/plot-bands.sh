srcDIR=$PWD
resultDIR="${srcDIR}/_result"
vasprunBANDS="${srcDIR}/07-bands/calc/mp-grid-15x15x1-slab-middle/vasprun.xml"
vasprunDOS="${srcDIR}/06-dos/calc/gm-grid-15x15x1-slab-middle-ISMEAR_-5/vasprun.xml"
mplStyle="${srcDIR}/matlotlib.rc"
mkdir -p "$resultDIR"
cd $resultDIR || exit 1

## Bands only
sumo-bandplot \
    -f $vasprunBANDS \
    -p only \
    --ymin -2 \
    --ymax  2 \
    --format svg \
    --style ${mplStyle} \
    --zero-line
    # --height 60 \ 
    # --width 75 \
# mv band.svg bands-only.svg

## Bands along with DOS
sumo-bandplot \
    -f ${vasprunBANDS} \
    -p merged \
    --dos ${vasprunDOS} \
    --ymin -2 \
    --ymax  2 \
    --format svg \
    --style ${mplStyle} \
    --legend-cutoff 2.5 \
    --zero-line



## Projected DOS
sumo-bandplot \
    -f ${vasprunBANDS} \
    -p projected \
    --ymin -2 \
    --ymax  2 \
    --format svg \
    --zero-line  \
    --style ${mplStyle} \
    --mode stacked \
    --project Se.s,Se.p,Sn.s,Sn.p \
    --circle-size 60 \
    --zero-line
## Projected Bands with DOS
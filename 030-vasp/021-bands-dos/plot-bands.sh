srcDIR=$PWD
resultDIR="${srcDIR}/_result"
vasprunBANDS="${srcDIR}/07-bands/calc/mp-grid-15x15x1-slab-middle/vasprun.xml"
vasprunDOS="${srcDIR}/06-dos/calc/gm-grid-15x15x1-slab-middle-ISMEAR_-5/vasprun.xml"
mplStyle="${srcDIR}/matlotlib.rc"
mm="0.0393701"
width=$(echo 75*$mm | bc -l )
height=$(echo 60*$mm | bc -l )
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
    --width ${width} \
    --height ${height} \
    --zero-line
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
    --width ${width} \
    --height ${height} \
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
    --width ${width} \
    --height ${height} \
    --zero-line
## Projected Bands with DOS
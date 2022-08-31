#!/bin/bash
find_and_replace() {
    # First Argument is old relax.in
    # Second in relax.out file contained relaxed coordinates
    # output file where to where to write
    tempfile=asdlhgfasdl
    o_start=$(awk '/Begin final/ {print NR}' $2)
    o_end=$(awk '/End final/ {print NR}' $2)
    i_start=$(awk '/CELL_PARA/ {print NR}' $1)
    awk -v i_start="$i_start" 'NR<=i_start{print}' $1 >$tempfile
    awk -v o_start="$o_start" -v o_end="$o_end" 'NR>4+o_start && NR<o_end {print}' $2 >>$tempfile
    echo "" >>$tempfile
    mv $tempfile $3
}

find_and_replace GeS.relax.in GeS.relax.out GeS.relax.in

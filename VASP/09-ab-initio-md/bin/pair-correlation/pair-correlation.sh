#!/bin/bash

awk < PCDAT$1 > pair_correlation$1.dat '
NR==8 { pcskal=$1}
NR==9 { pcfein=$1}
NR>=13 {
 line=line+1
 if (line==257)  {
    print " "
    line=0
 }
 else
    print (line-0.5)*pcfein/pcskal,$1
}
'

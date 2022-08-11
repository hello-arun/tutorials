# Run

## Graphene On the Hole Potassium


## POTCAR

Code used to get POTCAR file

```bash
ppDIR=/sw/xc40cle7/vasp/pot54/potpaw_PBE
rm POTCAR
cat $ppDIR/C/POTCAR $ppDIR/Na_pv/POTCAR >>POTCAR
# _pv PP treat one of the inner p core as valance
# so total 7 valance electrons for K
```
I wanted to study effect of hydrogen adsorbtion on different layers of graphehene.

I have successfully evaluated results for 2-Layer graphene and I have results with me.

Insted of manually creating the POSCAR files for 3L and 4L graphene I aim to use the data that I already have 
for 2L graphene.

since graphene have ABAB stacking so.. the top layer in 2L and 4L graphene would be same. but for 3L graphene it
would be slightly shifted one.

I have file in following format
```
{X}L.{Y}.K{Z}
wherer
X : No of layer of grapheen
Y : Configuration id
    1 : Prisitine graphene structure
    2 : Nitrogen doped graphene
    3 : Graphene with V1 vacancy
    4 : Graphene with V1 vacancy with N-doped on edge of vacany
    5 : Graphene with V2 vacancy
Z : No of Potassium atoms adsorbed
```

I will use `2L.4.K4` as a reference and generate `3L.4.K4` and `4L.4.K4`.
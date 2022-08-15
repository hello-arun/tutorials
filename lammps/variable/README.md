# Variable

**Also check [print-to-file](../print-to-file/INCAR.lmp) for additional variable use cases**

Concept of variable is different in LAMMPS as compared to programmming languages
like Python/Java/C. Variable in lammps are more like function in Python. They are
evaluated everytime any fix or compute try to use them. But we can also define
constant variables by using some tricks. Here we will discuss both the cases. 

So basically the two types of variables are

1. [Constant Varialbes](#constant-varibales) : Value do not change 
2. [Inconstant Variables](#inconstant-variables) : Evaluated everytime when used

## Constant varibales

These values of these variables are calaculated instantly and are not changed therafter untill we redifne the variable. There are various ways we can implement them

1. Using `string`

    Variable of type `string` are constant in lammps. Ex.
    ```
    variable VNAME string lx
    ```

2. Using `equal` and `$()`
    
    Variable of type `equal` are calculated every time they are used but using `$(expression)` force lammps to caluclate  expression instantly.
    ```
    variable VNAME equal $(lx) 
    ```

## Inconstant variables

These variables are caluculated everytime any `fix` or `compute` try to use them in a run.

1. Using equal

    Equal style variable are variable. `DONOT` use `$(expression)` if you need the variable nature of this variable. They are calculated everytime any `fix` or `compute` use them.
    ```
    variable VNAME equal lx   # Using thermo keyword lx
    variable VNAME equal v_V2 # Accessing another variable V2
    ``` 

## Brief

To sum it up we can have following cases

```
variable v0 string lx       # Constant
variabel v1 equal  $(lx)    # This is also constant
variable v2 equal  lx       # Inconstant 
variable v3 string lx*2     # Constant
varialbe v4 string lx * 2   # Error -- Space is not allowed in expression
variable v5 equal v_v2      # Inconstant 

```



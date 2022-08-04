# Polarisation using Berry-Phase

This will guide you to calculate Polarization via Berry-Phase approach in Quantum Espresso. This is obtained from documentation header of [PW/src/bp_c_phase.f90](https://gitlab.com/QEF/q-e/-/blob/develop/PW/src/bp_c_phase.f90). 

## BRIEF SUMMARY OF THE METHODOLOGY                                         

The spontaneous polarization has two contibutions, electronic and ionic. The ionic 
contribution is relatively trivial to compute, requiring knowledge only of the atomic 
positions and core charges. PWSCF will output both.

The standard procedure would be for the user to first perform a self-consistent (scf)
calculation to obtain a converged charge density. With well-converged sc charge
density, the user would then run one or more non-self consistent (or "band structure")
calculations, using the same main code, but with a flag to ask for the polarization.
Each such run would calculate the projection of the polarization onto one of the three
primitive reciprocal lattice vectors. In cases of high symmetry (e.g. a tetragonal
ferroelectric phase), one such run would suffice. In the general case of low symmetry,
the user would have to submit up to three jobs to compute the three components of
polarization, and would have to obtain the total polarization "by hand" by summing these
contributions.

Accurate calculation of the electronic or "Berry-phase" polarization requires overlaps between wavefunctions along fairly dense lines (or "strings") in k-space in the direction of the primitive G-vector for which one is calculating the projection of the polarization. The
code would use a higher-density k-mesh in this direction, and a standard-density mesh in the two other directions. 

### Params                                                     
                                                                            
   * lberry (.TRUE. or .FALSE.)                                             
     Tells PWSCF that a Berry phase calcultion is desired.                  
                                                                            
   * gdir (1, 2, or 3)                                                      
     Specifies the direction of the k-point strings in reciprocal space.
     '1' refers to the first reciprocal lattice vector, '2' to the
     second, and '3' to the third.                                          
                                                                            
   * nppstr (integer)                                                       
     Specifies the number of k-points to be calculated along each
     symmetry-reduced string.                                               
                                                                            
                                                                            
### EXPLANATION OF K-POINT MESH                                              

If gdir=1, the program takes the standard input specification of the
k-point mesh (nk1 x nk2 x nk3) and stops if the k-points in dimension
1 are not equally spaced or if its number is not equal to nppstr,
working with a mesh of dimensions (nppstr x nk2 x nk3).  That is, for
each point of the (nk2 x nk3) two-dimensional mesh, it works with a
string of nppstr k-points extending in the third direction.  Symmetry
will be used to reduce the number of strings (and assign them weights)
if possible.  Of course, if gdir=2 or 3, the variables nk2 or nk3 will
be overridden instead, and the strings constructed in those
directions, respectively.                                                
                                                                            
                                                                            
## References
The theory behind this implementation is described in:                   

 *   [1] R D King-Smith and D Vanderbilt, "Theory of polarization of
       crystaline solids", Phys Rev B 47, 1651 (1993).                      
                                                                            
 *  [2] D Vanderbilt and R D King-Smith, "Electronic polarization in the
       ultrasoft pseudopotential formalism", internal report (1998),        
 *  [3] D Vanderbilt, "Berry phase theory of proper piezoelectric
       response", J Phys Chem Solids 61, 147 (2000).                        
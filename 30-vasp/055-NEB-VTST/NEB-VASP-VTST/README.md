# How To Do (Needs revision)
1. Atomic Relax initial and final poscar. as in 1-initial and 2-final folder.
2. Copy to relaxed contcars and outcars to 3-intermediate/data folder.
    ```bash
    cd 3-intermediate/data
    bash copy-initial-final.sh
    ```
3. Then check for number of intermediate images and submit the calculaitons.
keep in mind to have number of nodes = integer multiple of numImages.
4. when  calculaitons have converged, run a postProcessing step to extract the Minimum energy path
and spline fit it. to fit use VTST tools scripts.
5. Now you can plot the results with python.
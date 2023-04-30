*Note that, unless you specify wf_collect=.true. in your pw.x input
file, you must run pw2wannier90 with the same number of processors as pw.x*

As opposed to ex-01 only this INCAR.win file is little bit changed. The changes are 
```
wannier_plot = .true.
wannier_plot_supercell = 3
wannier_plot_format = cube
wannier_plot_mode = crystal
wannier_plot_radius = 2.5
wannier_plot_scale = 1.0
```
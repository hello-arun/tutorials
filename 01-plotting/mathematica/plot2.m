(* Step 1: Save the data in a file "data.csv" *)

(* Step 2: Import the data *)
data = Import["./data.csv"];

(* Step 3: Plot the data *)
plot = ListLinePlot[data, 
 PlotStyle -> PointSize[Medium], 
 PlotRange -> All, 
 Frame -> True, 
 FrameLabel -> {"x", "y"}, 
 GridLines -> Automatic, 
 GridLinesStyle -> LightGray, 
 PlotLabel -> "Data Plot",
 BaseStyle -> {FontSize -> 12,FontFamily -> "Latin Modern Roman" (* Or "Latin Modern Roman" *)}
 ]
Export["./plot2.svg", plot]
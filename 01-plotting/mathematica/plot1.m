(* Define the function to plot *)
myFunction[x_] := Sin[x]

(* Create the plot *)
plot = Plot[myFunction[x], {x, 0, Pi}, 

  ImageSize -> {600, 400}, (* Adjust image size as needed *)
  BaseStyle -> {FontSize -> 12,FontFamily -> "Latin Modern Roman" (* Or "Latin Modern Roman" *)},
  (* Adjust font size as needed *)
  PlotRange -> {-1, 1} (* Adjust plot range as needed *)
];

(* Export the plot as SVG *)
Export["plot1.svg", plot, "SVG"];

(* Print confirmation message *)
Print["Plot saved as plot1.svg"];


// Finished perspective view.
//cmdline: --imgsize=2048,1536
include <../common/echo-camera-arg.scad>

include <params.scad>
use <perfume-display.scad>

$fs = 0.1;
$fa = 5;

$vpr = [ 60.90, 0.00, 39.20 ];
$vpt = [ 17.09, 5.09, 3.58 ];
$vpd = 55.18;

module example_vial(diameter, height) {
    radius = diameter / 2 - 0.01;
    color([1, 1, 1, 0.5])
        cylinder(r=radius, h=height * 0.85);
    translate([0, 0, height * 0.85 - 0.01])
        color([0, 0, 0, 0.75])
        cylinder(r=radius, h=height * 0.15);
}

function startOfRow(r, currentRow=0, vialsPassed=0) =
    (r == currentRow)
    ? vialsPassed
    : startOfRow(r, currentRow+1, vialsPassed + vialsInRow(currentRow));

vials = vialPositions();

assembly();

for (i = [0 : intMaxVials().y - 1])
    let (start = startOfRow(i))
        for (j = [start : start + floor(vialsInRow(i) / 2) - 1])
            translate(staticBorder() + dynamicBorder() + vials[j][0])
                example_vial(vials[j][1], (plankSize.z - vials[j][0].z) * 3);

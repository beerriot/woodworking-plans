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

function start_of_row(r, current_row=0, vials_passed=0) =
    (r == current_row)
    ? vials_passed
    : start_of_row(r, current_row+1, vials_passed + vials_in_row(current_row));

vials = vial_positions();

assembly();

for (i = [0 : int_max_vials().y - 1])
    let (start = start_of_row(i))
        for (j = [start : start + floor(vials_in_row(i) / 2) - 1])
            translate(static_border() + dynamic_border() + vials[j][0])
                example_vial(vials[j][1], (plank_size.z - vials[j][0].z) * 3);

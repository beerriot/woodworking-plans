//cmdline: --imgsize=800,750
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

use <../common/labeling.scad>

$vpr=[ 90.90, 0.00, 359.10 ];
$vpt=[ 15.48, 3.21, 12.84 ];
$vpf=22.50;
$vpd=86.87;

side(fancy_edges=false);

riser_rotate()
translate([riser_length() - arm_width,
           0,
           -arm_length() + riser_width + cleat_base_depth()/2])
rotate([0, -90-tilt, 0])
arrow(foot_width, wood_thickness);

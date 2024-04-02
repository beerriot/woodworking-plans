//cmdline: --imgsize=850,750
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

use <../common/labeling.scad>

$vpr=[ 90.90, 0.00, 359.10 ];
$vpt=[ 15.48, 3.21, 12.84 ];
$vpf=22.50;
$vpd=86.87;

side();

riser_rotate()
translate([riser_length() + wood_thickness / 2,
           0,
           -arm_length() + riser_width - wood_thickness * sin(tilt)])
rotate([0, 180-tilt, 0])
arrow(foot_width, wood_thickness);

translate([foot_length(), 0, foot_width / 2])
rotate([0, 90, 0])
arrow(foot_width, wood_thickness);

translate([0, 0, foot_width / 2])
rotate([0, -90, 0])
arrow(foot_width, wood_thickness);

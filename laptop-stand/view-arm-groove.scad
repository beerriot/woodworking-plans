//cmdline: --imgsize=1024,540
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

// An attempt to give me warnings if build instructions change.
use <view-tilt-cut.scad>
use <view-arm-cleat.scad>

use <../common/labeling.scad>

$vpr=[ 90.90, 0.00, 2.60 ];
$vpt=[ 12.29, 3.19, 1.34 ];
$vpf=22.50;
$vpd=44.08;

translate([0, arm_width, 0])
rotate([90, 0, 0])
arm();

translate([riser_width, 0, -(riser_length() + wood_thickness)])
rotate([0, -90, 0])
riser_view_tilt_cut();

translate([0, 0, -wood_thickness * 0.95])
guide(wood_thickness * 0.9);

translate([riser_width, 0, -wood_thickness * 0.95])
guide(wood_thickness * 0.9);

translate([arm_length() - cleat_base_depth(), 0, wood_thickness * 2])
cleat_view_arm_cleat();

translate([arm_length() - cleat_base_depth(),
           0,
           wood_thickness * 1.05])
guide(wood_thickness * 0.9);

translate([arm_length(),
           0,
           wood_thickness * 1.05])
guide(wood_thickness * 0.9);

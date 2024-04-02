//cmdline: --imgsize=1024,540
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

// An attempt to give me warnings if build instructions change.
use <view-tilt-cut.scad>
use <view-arm-cleat.scad>

use <../common/labeling.scad>

$vpr=[ 95.10, 0.00, 19.40 ];
$vpt=[ 13.47, 3.18, 2.52 ];
$vpf=22.50;
$vpd=44.08;

arm(cut_grooves=false);

// make a ghost just barely smaller to show what was removed
ghost_adjust = [0.01, 0.01, 0.01];
color([0.5, 0.5, 0.5, 0.25])
translate(ghost_adjust)
cube([arm_length(), wood_thickness, arm_width] - ghost_adjust * 2);

translate([riser_width, 0, -(riser_length() + wood_thickness)])
rotate([0, -90, 0])
riser_view_tilt_cut();

translate([0, 0, -wood_thickness * 0.95])
guide(wood_thickness * 0.9);

translate([riser_width, 0, -wood_thickness * 0.95])
guide(wood_thickness * 0.9);

translate([arm_length() + wood_thickness, 0, arm_width])
rotate([0, 90, 0])
cleat_view_arm_cleat();

translate([arm_length() + wood_thickness * 0.05,
           0,
           arm_width])
rotate([0, 90, 0])
guide(wood_thickness * 0.9);

translate([arm_length() + wood_thickness * 0.05,
           0,
           arm_width - cleat_base_depth()])
rotate([0, 90, 0])
guide(wood_thickness * 0.9);

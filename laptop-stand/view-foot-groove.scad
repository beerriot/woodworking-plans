//cmdline: --imgsize=1024,540
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

// An attempt to give me warnings if build instructions change.
use <view-tilt-cut.scad>

use <../common/labeling.scad>

$vpr=[ 96.50, 0.00, 359.80 ];
$vpt=[ 5.24, 3.29, 2.75 ];
$vpf=22.50;
$vpd=44.08;

foot(cut_fancy_ends=false);

translate([(foot_width + wood_thickness) * tan(tilt),
           0,
           foot_width + wood_thickness])
rotate([0, -90+tilt, 0])
translate([0, 0, -riser_width])
riser_view_tilt_cut();

translate([0, 0, -wood_thickness * 2])
rotate([90, 0, 0])
foot(cut_fancy_ends=false);

translate([(foot_width + 0.05 * wood_thickness)  * tan(tilt),
           0,
           foot_width + 0.05 * wood_thickness])
rotate([0, tilt, 0])
guide(wood_thickness * 0.9);


translate([riser_width / cos(tilt), 0, 0])
rotate([0, tilt, 0])
guide(foot_width + wood_thickness * 0.95);

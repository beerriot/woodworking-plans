// Show the tray with chamfer and groove shaped.
//cmdline: --projection=o --imgsize=2048,1280
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <perfume-display.scad>

$vpr = [ 90.00, 0.00, 0.00 ];
$vpt = [ 14.21, 10.39, 15.06 ];
$vpd = 66.80;

third_angle([plank_size.x, plank_size.z, plank_size.y]) {
    translate([0, plank_size.z, 0]) rotate([90, 0, 0]) {
        assembly();
        fill_holes_for_orthographic();
    }

    union() { }
    ta_right_side(plank_size.x) { }
    ta_top_side(plank_size.y) { }
}

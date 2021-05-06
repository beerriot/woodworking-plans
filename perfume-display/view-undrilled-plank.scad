// Show the size of the plank.
//cmdline: --projection=o --imgsize=2048,1280
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <perfume-display.scad>

$vpr = [ 90.00, 0.00, 0.00 ];
$vpt = [ 15.47, 6.62, 12.22 ];
$vpd = 73.83;

third_angle([plank_size.x, plank_size.z, plank_size.y]) {
    color(plank_color)
        translate([0, plank_size.z, 0])
        rotate([90, 0, 0])
        plank();

    size_label(plank_size.x);

    ta_right_side(plank_size.x) {
        size_label(plank_size.z);
        translate([plank_size.z, 0]) size_label(plank_size.y, rotation=-90);
    }
}

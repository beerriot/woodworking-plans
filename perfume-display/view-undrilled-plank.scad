// Label offsets for drilling holes.
//cmdline: --projection=o --imgsize=2048,1280
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <perfume-display.scad>

$vpr = [ 90.00, 0.00, 0.00 ];
$vpt = [ 15.47, 6.62, 12.22 ];
$vpd = 73.83;

thirdAngle([plankSize.x, plankSize.z, plankSize.y]) {
    color(plankColor)
        translate([0, plankSize.z, 0])
        rotate([90, 0, 0])
        plank();

    sizeLabel(plankSize.x);

    taRightSide(plankSize.x) {
        sizeLabel(plankSize.z);
        translate([plankSize.z, 0]) sizeLabel(plankSize.y, rotation=-90);
    }
}

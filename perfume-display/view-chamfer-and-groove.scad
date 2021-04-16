// Label offsets for drilling holes.
//cmdline: --projection=o --imgsize=2048,1280
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <perfume-display.scad>

$vpr = [ 90.00, 0.00, 0.00 ];
$vpt = [ 14.21, 10.39, 15.06 ];
$vpd = 66.80;

thirdAngle([plankSize.x, plankSize.z, plankSize.y]) {
    translate([0, plankSize.z, 0]) rotate([90, 0, 0]) {
        assembly();
        fillHolesForOrthographic();
    }

    union() { }
    taRightSide(plankSize.x) { }
    taTopSide(plankSize.y) { }
}

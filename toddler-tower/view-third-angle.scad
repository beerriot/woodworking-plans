//cmdline: --projection=o --imgsize=2048,2048
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>

include <params.scad>

$vpt = [ 54.17, 38.87, 72.47 ];
$vpr = [ 90.00, 0.00, 0.00 ];
$vpd = 395.22;

thirdAngle([width, bottom_depth, height]) {
    assembly();

    sizeLabel(width);

    taRightSide(bottom_depth) {
        sizeLabel(bottom_depth);
        translate([bottom_depth, 0, 0]) sizeLabel(height, rotation=-90);
        translate([bottom_depth - platform_depth, 0, height])
            sizeLabel(platform_depth, over=true);
    }

    taTopSide(height) { }
};

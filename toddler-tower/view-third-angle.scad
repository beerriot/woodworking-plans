//cmdline: --projection=o --imgsize=2048,2048
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>

include <params.scad>

$vpt = [ 54.17, 38.87, 72.47 ];
$vpr = [ 90.00, 0.00, 0.00 ];
$vpd = 395.22;

third_angle([width, bottom_depth + thickness, height],
            front_labels=[1,0,1]) {
    assembly();

    size_label(width);

    ta_right_side(bottom_depth) {
        size_label(bottom_depth);
        translate([bottom_depth, 0, 0]) size_label(height, rotation=-90);
        translate([bottom_depth - platform_depth, 0, height])
            size_label(platform_depth, over=true);
    }

    ta_top_side(height) { }
};

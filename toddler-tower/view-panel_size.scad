//cmdline: --projection=o --imgsize=1152,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>
use <panel-build.scad>

include <params.scad>

$vpt = panel_vpt();
$vpr = panel_vpr();
$vpd = panel_vpd();

module view_panel_size() {
    side_panel_blank();
}

showBothSides() view_panel_size();

translate([0, bottom_depth, 0]) {
    viewLabel() size_label(bottom_depth);
    viewLabel() size_label(height, over=true, rotation=-90);
}

leftOrigin() {
    viewLabel() size_label(bottom_depth);
}

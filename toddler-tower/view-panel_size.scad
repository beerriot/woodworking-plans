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
    viewLabel() sizeLabel(bottom_depth);
    viewLabel() sizeLabel(height, over=true, rotation=-90);
}

leftOrigin() {
    viewLabel() sizeLabel(bottom_depth);
}

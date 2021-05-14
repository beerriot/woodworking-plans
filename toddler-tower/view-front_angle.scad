//cmdline: --projection=o --imgsize=1152,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>
use <panel-build.scad>

include <params.scad>

use <view-support_rabbets.scad>

$vpt = panel_vpt();
$vpr = panel_vpr();
$vpd = panel_vpd();

module view_front_angle() {
    difference() {
        view_support_rabbets();

        front_angle_cut();
    }
}

show_both_sides() view_front_angle();

// top of bottom step
view_label()
size_label(front_step_heights[0], rotation=-90);

// safety rail
translate([height, bottom_depth, thickness])
    view_label() size_label(platform_depth, over=true);

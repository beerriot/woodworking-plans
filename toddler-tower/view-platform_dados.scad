//cmdline: --projection=o --imgsize=1152,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>
use <panel-build.scad>

include <params.scad>

use <view-panel_size.scad>

$vpt = panel_vpt();
$vpr = panel_vpr();
$vpd = panel_vpd();

module view_platform_dados() {
    difference() {
        view_panel_size();

        all_platform_dados();
        all_front_step_dados();
    }
}

showBothSides() view_platform_dados();

translate([0, bottom_depth, thickness]) {
    translate([platform_heights[0] - thickness, 0, 0]) {
        viewLabel() size_label(platform_depth);
        translate([0, -platform_depth, 0])
            viewLabel() size_label(thickness, rotation=-90);
    }

    for (i = [0 : len(platform_heights) - 1])
        translate([0, size_label_height() * i, 0])
            viewLabel()
            size_label(platform_heights[i], over=true, rotation=-90);
}

leftOrigin(thickness) {
    for (i = [0 : len(front_step_heights) - 1]) {
        translate([0, size_label_height() * i, 0])
            viewLabel()
            size_label(front_step_heights[i], over=true, rotation=-90);
        translate([front_step_heights[i] - thickness, 0, 0])
            viewLabel()
            size_label(front_step_depth() + front_step_inset(front_step_heights[i]));
    }
}

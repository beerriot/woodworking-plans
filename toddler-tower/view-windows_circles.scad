//cmdline: --projection=o --imgsize=1152,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>
use <panel-build.scad>

include <params.scad>

use <view-handholds_flats.scad>

$vpt = panel_vpt();
$vpr = panel_vpr();
$vpd = panel_vpd();

module view_windows_circles() {
    difference() {
        view_handholds_flats();

        all_windows(connect_circles=false);
    }
}

showBothSides() view_windows_circles();

// upper window
translate([height, bottom_depth, thickness]) {
    translate([0, -upper_window_inset(), 0])
        viewLabel() sizeLabel(upper_window_inset(), rotation=90, over=true);
    translate([-upper_window_inset(), 0, 0])
        viewLabel() sizeLabel(upper_window_inset(), over=true);

    translate([0, -(upper_window_inset() + upper_window_top_depth()), 0])
        viewLabel() sizeLabel(upper_window_inset(), rotation=90, over=true);
    translate([-upper_window_inset(), 0, 0])
        viewLabel() sizeLabel(upper_window_inset() + upper_window_top_depth());
}

leftOrigin(thickness) {
    translate([height, -bottom_depth, 0]) {
        translate([0, upper_window_inset(), 0])
            viewLabel() sizeLabel(upper_window_inset() + upper_window_height(),
                                  rotation=90);
        translate([-(upper_window_inset() + upper_window_height()),
                   upper_window_inset(),
                   0])
            viewLabel() sizeLabel(upper_window_inset(), over=true);

        translate([0, upper_window_inset() + upper_window_bottom_depth(), 0])
            viewLabel() sizeLabel(upper_window_inset() + upper_window_height(),
                                  rotation=90);
        translate([-(upper_window_inset() + upper_window_height()),
                   upper_window_inset() + upper_window_bottom_depth(),
                  0])
            viewLabel() sizeLabel(upper_window_bottom_depth() +
                                  upper_window_inset());
    }
}

// bottom window
translate([0, 0, thickness]) {
    translate([0,
               lower_window_inset() + lower_window_upper_corner_offset(),
               0]) {
        viewLabel() sizeLabel(lower_window_height(), rotation=-90, over=true);
        translate([lower_window_height(), 0, 0])
            viewLabel() sizeLabel(front_step_depth() + handhold_size[1] / 2);
    }

    translate([0,
               lower_window_inset() + lower_window_upper_corner_offset()
               + lower_window_top_depth(),
               0]) {
        viewLabel() sizeLabel(lower_window_height(), rotation=-90, over=true);
        translate([lower_window_height(), 0, 0])
            viewLabel() sizeLabel(front_step_depth() * 2
                                  + handhold_size[1] / 2,
                                  over=true);
    }

}

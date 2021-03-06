//cmdline: --projection=o --imgsize=1152,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <../common/math_funcs.scad>
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

        upper_window_position() upper_window_cutout_circles();
        lower_window_position() lower_window_cutout_circles();
    }
}

show_both_sides() view_windows_circles();

// upper window
translate(upper_window_position() + [0, 0, thickness]) {
    view_label() size_label(upper_window_inset(), rotation=-90);
    view_label() size_label(upper_window_inset(), rotation=180);

    translate([0, -upper_window_top_depth(), 0]) {
        view_label() size_label(upper_window_inset(), rotation=-90);
        view_label() size_label(upper_window_inset() + upper_window_top_depth(),
                              rotation=180,
                              over=true);
    }
}

translate(left_origin()
          + scale([1,-1,1], upper_window_position())
          + [-upper_window_height(), 0, thickness]) {
    view_label() size_label(upper_window_inset() + upper_window_height(),
                          rotation=-90, over=true);
    view_label() size_label(upper_window_inset(), over=true);

    translate([0, upper_window_bottom_depth(), 0]) {
        view_label() size_label(upper_window_inset() + upper_window_height(),
                              rotation=-90, over=true);
        view_label() size_label(upper_window_bottom_depth() +
                              upper_window_inset());
    }
}

// bottom window
translate([0, lower_window_upper_corner_offset(), thickness])
lower_window_position() {
    view_label() size_label(lower_window_height(), rotation=-90, over=true);
    translate([lower_window_height(), 0, 0])
        view_label() size_label(front_step_depth() + cutout_radius());

    translate([0, lower_window_top_depth(), 0]) {
        view_label() size_label(lower_window_height(), rotation=-90, over=true);
        translate([lower_window_height(), 0, 0])
            view_label() size_label(front_step_depth()
                                  + lower_window_top_depth()
                                  + cutout_radius(),
                                  over=true);
    }

}

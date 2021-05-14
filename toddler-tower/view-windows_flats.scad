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

module view_windows_flats() {
    difference() {
        view_handholds_flats();

        all_windows();
    }
}

show_both_sides() view_windows_flats();

translate([0, lower_window_inset(), thickness])
view_label() size_label(lower_window_inset());

translate([0, bottom_depth, thickness])
view_label() size_label(bottom_depth - lower_window_bottom_depth() - lower_window_inset());

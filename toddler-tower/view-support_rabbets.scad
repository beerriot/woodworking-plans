//cmdline: --projection=o --imgsize=1152,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>
use <panel-build.scad>

include <params.scad>

use <view-platform_dados.scad>

$vpt = panel_vpt();
$vpr = panel_vpr();
$vpd = panel_vpd();

module view_support_rabbets() {
    difference() {
        view_platform_dados();

        all_rabbets_and_grooves();
    }
}

show_both_sides() view_support_rabbets();

// under step
translate([0, (front_step_depth() + thickness) / 2, 0])
view_label()
size_label((front_step_depth() + thickness) / 2);

// safety rail
translate([height, bottom_depth, thickness]) {
    view_label() size_label(platform_depth, over=true);
    translate([0, -platform_depth, 0])
        view_label() size_label(safety_rail_height(), rotation=90, over=true);
}

// wide support
translate([height,
           bottom_depth,
           thickness])
view_label()
size_label(wide_support_height() * 0.25 + narrow_support_height(),
          rotation=90);
translate([height - wide_support_height() * 1.25 - narrow_support_height(),
           bottom_depth,
           thickness])
view_label()
size_label(wide_support_height(), over=true, rotation=-90);

left_origin(thickness) {
    translate([0, -bottom_depth, 0]) {
        // bottom cabinet side
            view_label()
            size_label(thickness, rotation=-90);
        translate([thickness, 0, 0])
            view_label()
            size_label(narrow_support_height(), rotation=-90);

        // top cabinet side
        translate([height, 0, 0])
            view_label()
            size_label(narrow_support_height(), rotation=90, over=true);
    }
}

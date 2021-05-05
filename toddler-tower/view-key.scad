//cmdline: --projection=o --imgsize=2048,2048
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>

include <params.scad>

$vpt = [ 30.84, 38.87, 116.00 ];
$vpr = [ 90.00, 0.00, 0.00 ];
$vpd = 610.90;

side_size = [height, thickness, bottom_depth];
platform_size = [inter_recess_span(), thickness, platform_depth];
step_size = [inter_recess_span(), thickness, front_step_depth()];
wide_support_size = [inter_recess_span(), thickness, wide_support_height()];
narrow_support_size =
    [inter_recess_span(), thickness, narrow_support_height()];
safety_rail_size = [inter_recess_span(), thickness, safety_rail_height()];

key([["RIGHT SIDE", 1, third_angle_size(side_size, top_labels=[1,0,0])],
     ["LEFT_SIDE", 1, third_angle_size(side_size, top_labels=[1,0,0])],
     ["PLATFORM", 1, third_angle_size(platform_size)],
     ["STEP", 1, third_angle_size(step_size)],
     ["WIDE SUPPORT", 1, third_angle_size(wide_support_size)],
     ["NARROW SUPPORT", 3, third_angle_size(narrow_support_size)],
     ["SAFETY_RAIL", 1, third_angle_size(safety_rail_size)]]) {
    third_angle(side_size, right_labels=undef) {
        translate([0, thickness, 0]) rotate([90, 0, 0]) right_side();

        translate([height, 0, bottom_depth - platform_depth])
            size_label(platform_depth, rotation=-90);
        ta_right_side(height) {}
        ta_top_side(bottom_depth) {
            translate([0, 0, thickness]) size_label(height, over=true);
        }

    }
    third_angle(side_size) {
        translate([0, thickness, bottom_depth])
            rotate([-90, 0, 0])
            left_side();
        union() {}
        ta_right_side(height) {
            size_label(thickness);
            translate([thickness, 0, 0]) size_label(bottom_depth, rotation=-90);
        }
        ta_top_side(bottom_depth) {}
    }
    third_angle(platform_size) {
        translate([0, thickness, 0]) rotate([90, 0, 0]) platform();

        size_label(inter_recess_span());
        ta_right_side(inter_recess_span()) {
            translate([0, 0, platform_depth]) size_label(thickness, over=true);
            translate([thickness, 0, 0])
                size_label(platform_depth, rotation=-90);
        }
    }
    third_angle(step_size) {
        translate([0, thickness, 0]) rotate([90, 0, 0]) front_step();

        union() {}
        ta_right_side(inter_recess_span()) {
            translate([thickness, 0, 0])
                size_label(front_step_depth(), rotation=-90);
        }
    }
    third_angle(wide_support_size) {
        translate([0, thickness, 0]) rotate([90, 0, 0]) wide_support();

        union() {}
        ta_right_side(inter_recess_span()) {
            translate([thickness, 0, 0])
                size_label(wide_support_height(), rotation=-90);
        }
    }
    third_angle(narrow_support_size) {
        translate([0, thickness, 0]) rotate([90, 0, 0]) narrow_support();

        union() {}
        ta_right_side(inter_recess_span()) {
            translate([thickness, 0, 0])
                size_label(narrow_support_height(), rotation=-90);
        }
    }
    third_angle(safety_rail_size) {
        translate([0, thickness, 0]) rotate([90, 0, 0]) safety_rail();

        union() {}
        ta_right_side(inter_recess_span()) {
            translate([thickness, 0, 0])
                size_label(safety_rail_height(), rotation=-90);
        }
    }
}

//cmdline: --projection=o --imgsize=2048,2048
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>

include <params.scad>

$vpt = [ 17.62, 38.87, 36.95 ];
$vpr = [ 90.00, 0.00, 0.00 ];
$vpd = 211.52;

platform_size = [inter_recess_span(), thickness, platform_depth];
step_size = [inter_recess_span(), thickness, front_step_depth()];
wide_support_size = [inter_recess_span(), thickness, wide_support_height()];
narrow_support_size =
    [inter_recess_span(), thickness, narrow_support_height()];
safety_rail_size = [inter_recess_span(), thickness, safety_rail_height()];

key([["NARROW SUPPORT", 3, narrow_support_size],
     ["WIDE SUPPORT", 1, wide_support_size],
     ["SAFETY_RAIL", 1, safety_rail_size],
     ["STEP", 1, step_size],
     ["PLATFORM", 1, platform_size]]) {
    union() {
        rotate([90, 0, 0]) narrow_support();
        translate([inter_recess_span(), 0, 0])
            size_label(narrow_support_height(), rotation=-90);
    }
    union() {
        rotate([90, 0, 0]) wide_support();
        translate([inter_recess_span(), 0, 0])
            size_label(wide_support_height(), rotation=-90);
    }
    union() {
        rotate([90, 0, 0]) safety_rail();
        translate([inter_recess_span(), 0, 0])
            size_label(safety_rail_height(), rotation=-90);
    }
    union() {
        // -0.01 gets the curve out of the plane of the platform's
        // -removed curve, to avoid rendering conflicts
        translate([0, -0.01, front_step_depth()])
            rotate([-90, 0, 0])
            front_step();
        translate([inter_recess_span(), 0, 0])
            size_label(front_step_depth(), rotation=-90);
    }
    union() {
        rotate([90, 0, 0]) platform();
        translate([inter_recess_span(), 0, 0])
            size_label(platform_depth, rotation=-90);
    }
}

size_label(inter_recess_span());

//cmdline: --projection=o --imgsize=2048,2048
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>

include <params.scad>

$vpt = [ 30.84, 38.87, 116.00 ];
$vpr = [ 90.00, 0.00, 0.00 ];
$vpd = 610.90;

side_size = [height, thickness, bottom_depth];
platform_size = [inter_rabbet_span(), thickness, platform_depth];
step_size = [inter_rabbet_span(), thickness, front_step_depth()];
wide_support_size = [inter_rabbet_span(), thickness, wide_support_height()];
narrow_support_size =
    [inter_rabbet_span(), thickness, narrow_support_height()];
safety_rail_size = [inter_rabbet_span(), thickness, safety_rail_height()];

key([keyChildInfo("RIGHT SIDE", 1,
                  thirdAngleSize(side_size, topLabels=[1,0,0])),
     keyChildInfo("LEFT_SIDE", 1,
                  thirdAngleSize(side_size, topLabels=[1,0,0])),
     keyChildInfo("PLATFORM", 1,
                  thirdAngleSize(platform_size)),
     keyChildInfo("STEP", 1,
                  thirdAngleSize(step_size)),
     keyChildInfo("WIDE SUPPORT", 1,
                  thirdAngleSize(wide_support_size)),
     keyChildInfo("NARROW SUPPORT", 3,
                  thirdAngleSize(narrow_support_size)),
     keyChildInfo("SAFETY_RAIL", 1,
                  thirdAngleSize(safety_rail_size))]) {
    thirdAngle(side_size, rightLabels=undef) {
        translate([0, thickness, 0]) rotate([90, 0, 0]) right_side();

        translate([height, 0, bottom_depth - platform_depth])
            sizeLabel(platform_depth, rotation=-90);
        taRightSide(height) {}
        taTopSide(bottom_depth) {
            translate([0, 0, thickness]) sizeLabel(height, over=true);
        }

    }
    thirdAngle(side_size) {
        translate([0, thickness, bottom_depth])
            rotate([-90, 0, 0])
            left_side();
        union() {}
        taRightSide(height) {
            sizeLabel(thickness);
            translate([thickness, 0, 0]) sizeLabel(bottom_depth, rotation=-90);
        }
        taTopSide(bottom_depth) {}
    }
    thirdAngle(platform_size) {
        translate([0, thickness, 0]) rotate([90, 0, 0]) platform();

        sizeLabel(inter_rabbet_span());
        taRightSide(inter_rabbet_span()) {
            translate([0, 0, platform_depth]) sizeLabel(thickness, over=true);
            translate([thickness, 0, 0])
                sizeLabel(platform_depth, rotation=-90);
        }
    }
    thirdAngle(step_size) {
        translate([0, thickness, 0]) rotate([90, 0, 0]) front_step();

        union() {}
        taRightSide(inter_rabbet_span()) {
            translate([thickness, 0, 0])
                sizeLabel(front_step_depth(), rotation=-90);
        }
    }
    thirdAngle(wide_support_size) {
        translate([0, thickness, 0]) rotate([90, 0, 0]) wide_support();

        union() {}
        taRightSide(inter_rabbet_span()) {
            translate([thickness, 0, 0])
                sizeLabel(wide_support_height(), rotation=-90);
        }
    }
    thirdAngle(narrow_support_size) {
        translate([0, thickness, 0]) rotate([90, 0, 0]) narrow_support();

        union() {}
        taRightSide(inter_rabbet_span()) {
            translate([thickness, 0, 0])
                sizeLabel(narrow_support_height(), rotation=-90);
        }
    }
    thirdAngle(safety_rail_size) {
        translate([0, thickness, 0]) rotate([90, 0, 0]) safety_rail();

        union() {}
        taRightSide(inter_rabbet_span()) {
            translate([thickness, 0, 0])
                sizeLabel(safety_rail_height(), rotation=-90);
        }
    }
}

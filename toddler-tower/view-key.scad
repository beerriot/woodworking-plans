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
                  thirdAngleSize(side_size, topLabels=[1,0,1])),
     keyChildInfo("LEFT_SIDE", 1,
                  thirdAngleSize(side_size)),
     keyChildInfo("PLATFORM", 1,
                  thirdAngleSize(platform_size)),
     keyChildInfo("STEP", 1,
                  thirdAngleSize(step_size)),
     keyChildInfo("WIDE SUPPORT", 1,
                  thirdAngleSize(wide_support_size)),
     keyChildInfo("NARROW SUPPORT", 1,
                  thirdAngleSize(narrow_support_size)),
     keyChildInfo("SAFETY_RAIL", 1,
                  thirdAngleSize(safety_rail_size))]) {
     thirdAngle(side_size) {
         translate([0, thickness, 0]) rotate([90, 0, 0]) right_side();

         union() {}
         taRightSide(height) {}
         taTopSide(bottom_depth) {}
     }
     thirdAngle(side_size) {
         translate([0, thickness, bottom_depth])
             rotate([-90, 0, 0])
             left_side();
         union() {}
         taRightSide(height) {}
         taTopSide(bottom_depth) {}
     }
     thirdAngle(platform_size) {
         translate([0, thickness, 0]) rotate([90, 0, 0]) platform();

         union() {}
         taRightSide(inter_rabbet_span()) {}
     }
     thirdAngle(step_size) {
         translate([0, thickness, 0]) rotate([90, 0, 0]) front_step();

         union() {}
         taRightSide(inter_rabbet_span()) {}
     }
     thirdAngle(wide_support_size) {
         translate([0, thickness, 0]) rotate([90, 0, 0]) wide_support();

         union() {}
         taRightSide(inter_rabbet_span()) {}
     }
     thirdAngle(narrow_support_size) {
         translate([0, thickness, 0]) rotate([90, 0, 0]) narrow_support();

         union() {}
         taRightSide(inter_rabbet_span()) {}
     }
     thirdAngle(safety_rail_size) {
         translate([0, thickness, 0]) rotate([90, 0, 0]) safety_rail();

         union() {}
         taRightSide(inter_rabbet_span()) {}
     }
}

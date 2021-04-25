//cmdline: --projection=o --imgsize=2048,1536
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <../common/hardware.scad>
use <toddler-tower.scad>

include <params.scad>

$vpt = [ -14.28, 38.87, 13.28 ];
$vpr = [ 90.00, 0.00, 0.00 ];
$vpd = 92.99;

insert_size = [threaded_insert_od, 1, threaded_insert_od];
bolt_size = [bolt_head_diameter, bolt_length(), bolt_head_diameter];
screw_size = [0.6, screw_length(), 0.6];
washer_size = [0.8, 0.3, 0.8];

key([keyChildInfo("DECK SCREW", 18,
                  thirdAngleSize(screw_size, topLabels=undef)),
     keyChildInfo("FINISH_WASHER", 18,
                  thirdAngleSize(washer_size, topLabels=undef)),
     keyChildInfo("BOLT", 8,
                  thirdAngleSize(bolt_size, topLabels=undef)),
     keyChildInfo("THREADED_INSERT", 8,
                  thirdAngleSize(insert_size, topLabels=undef))]) {
    thirdAngle(screw_size) {
        translate([0.3, 0, 0.3]) rotate([-90, 0, 0]) screw();

        union() {}
        taRightSide(screw_length()) {
            translate([finish_washer_height(), 0, 0])
                sizeLabel(screw_length());
        }
    }
    thirdAngle(washer_size) {
        translate([0.4, 0, 0.4]) rotate([-90, 0, 0]) tt_finish_washer();

        union() {}
        taRightSide(finish_washer_height()) {}
    }
    thirdAngle(bolt_size, frontLabels=[0,0.5,1]) {
        translate([bolt_head_diameter / 2, 0, bolt_head_diameter / 2])
            rotate([-90, 0, 0])
            bolt();

        union() {
            sizeLabel(bolt_head_diameter);
        }

        taRightSide(bolt_length()) {
            translate([0.1, 0, 0]) sizeLabel(bolt_length());
        }
    }
    thirdAngle(insert_size) {
        translate([threaded_insert_od / 2, 0, threaded_insert_od / 2])
            rotate([-90, 0, 0])
            tt_threaded_insert();

        union() {
            sizeLabel(threaded_insert_od);
            translate([threaded_insert_od / 4, 0, 0])
                sizeLabel(threaded_insert_od / 2, over=true);
        }
        taRightSide(1) {
            sizeLabel(1);
        }
    }
}

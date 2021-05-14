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

key([["DECK SCREW", 18, third_angle_size(screw_size, top_labels=undef)],
     ["FINISH_WASHER", 18, third_angle_size(washer_size, top_labels=undef)],
     ["BOLT", 8, third_angle_size(bolt_size, top_labels=undef)],
     ["THREADED_INSERT", 8, third_angle_size(insert_size, top_labels=undef)]]) {
    third_angle(screw_size) {
        translate([0.3, 0, 0.3]) rotate([-90, 0, 0]) screw();

        union() {}
        ta_right_side(screw_length()) {
            translate([finish_washer_height(), 0, 0])
                size_label(screw_length());
        }
    }
    third_angle(washer_size) {
        translate([0.4, 0, 0.4]) rotate([-90, 0, 0]) tt_finish_washer();

        union() {}
        ta_right_side(finish_washer_height()) {}
    }
    third_angle(bolt_size, front_labels=[0,0.5,1]) {
        translate([bolt_head_diameter / 2, 0, bolt_head_diameter / 2])
            rotate([-90, 0, 0])
            bolt();

        union() {
            size_label(bolt_head_diameter);
        }

        ta_right_side(bolt_length()) {
            translate([0.1, 0, 0]) size_label(bolt_length());
        }
    }
    third_angle(insert_size) {
        translate([threaded_insert_od / 2, 0, threaded_insert_od / 2])
            rotate([-90, 0, 0])
            tt_threaded_insert();

        union() {
            size_label(threaded_insert_od);
            translate([threaded_insert_od / 4, 0, 0])
                size_label(threaded_insert_od / 2, over=true);
        }
        ta_right_side(1) {
            size_label(1);
        }
    }
}

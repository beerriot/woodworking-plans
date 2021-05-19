// Key to the bolts, screws, and such.
//cmdline: --projection=o --imgsize=2048,4096
include <../common/echo-camera-arg.scad>

use <signal-tower.scad>
include <params.scad>

use <../common/labeling.scad>
use <../common/math_funcs.scad>

$vpt = [ 6.58, 0.00, 23.56 ];
$vpr = [ 90.00, 0.00, 0.00 ];
$vpd = 132.78;
$vpf = 22.50;

key([["LEG BOLT", 3 * len(brace_elevations),
      third_angle_size([leg_bolt_head_size,
                        leg_bolt_length(),
                        leg_bolt_head_size],
                       top_labels=undef)],
     ["CLAMP BOLT", 2,
      third_angle_size([clamp_bolt_head_size,
                        pipe_clamp_bolt_length(),
                        clamp_bolt_head_size],
                       top_labels=undef)],
     ["WASHER", 6 * len(brace_elevations),
      [leg_washer_size().x, leg_washer_size().z, leg_washer_size().x]],
     ["NUT", 3 * len(brace_elevations),
      [leg_bolt_head_size, leg_bolt_diameter, leg_bolt_head_size]],
     ["T-NUT", 2,
      third_angle_size([clamp_t_nut_diameter * 3,
                        clamp_bolt_diameter * 2,
                        clamp_t_nut_diameter * 3],
                       front_labels=[0,0,0],
                       right_labels=[0,0,0],
                       top_labels=undef)],
     ["DECK SCREW", "MANY", rotate([0, -90, 0], hanger_screw_size)],
     ["BRACE HANGER", 3 * len(brace_elevations),
      third_angle_size(brace_hanger_panel_size(),
                       front_labels=[0,0,0],
                       right_labels=undef,
                       top_labels=undef)]]) {
    third_angle([leg_bolt_head_size,
                 leg_bolt_length(),
                 leg_bolt_head_size]) {
        translate([leg_bolt_head_size / 2, 0, leg_bolt_head_size / 2])
            rotate([-90, 0, 0])
            leg_bolt();
        union() { }
        ta_right_side(leg_bolt_head_size) {
            size_label(leg_bolt_length());
        }
    }

    third_angle([clamp_bolt_head_size,
                 pipe_clamp_bolt_length(),
                 clamp_bolt_head_size]) {
        translate([clamp_bolt_head_size / 2, 0, clamp_bolt_head_size / 2])
            rotate([-90, 0, 0])
            pipe_clamp_bolt();
        union() {}
        ta_right_side(clamp_bolt_head_size) {
            size_label(pipe_clamp_bolt_length());
        }
    }

    translate([leg_washer_size().x / 2, 0, leg_washer_size().x / 2])
        rotate([-90, 0, 0])
        leg_washer();


    translate([leg_bolt_head_size / 2, 0, leg_bolt_head_size / 2])
        rotate([-90, 0, 0])
        leg_nut();

    third_angle([clamp_t_nut_diameter * 3,
                 clamp_bolt_diameter * 2,
                 clamp_t_nut_diameter * 3],
                front_labels=[0,0,0],
                right_labels=[0,0,0],
                top_labels=undef) {
        translate([clamp_t_nut_diameter * 1.5, 0, clamp_t_nut_diameter * 1.5])
            rotate([-90, 0, 0])
            pipe_clamp_t_nut();
        union() { }
        ta_right_side(clamp_t_nut_diameter) { }
    }

    rotate([0, 90, 0])
        brace_hanger_screw();

    third_angle(brace_hanger_panel_size(),
                front_labels=[0,0,0],
                right_labels=undef) {
        translate([brace_hanger_panel_size().x * sin(30), 0, 0])
            brace_hanger();
        union() { }
        ta_right_side(brace_hanger_panel_size().x * 2) { }
        ta_top_side(brace_hanger_panel_size().z) { }
    }
}

// Key to the wood parts, plus the pipe because it's on the same scale.
//cmdline: --projection=o --imgsize=4096,2048
include <../common/echo-camera-arg.scad>

use <signal-tower.scad>
include <params.scad>

use <../common/labeling.scad>
use <../common/math_funcs.scad>

$vpt = [ 156.03, 0.00, 32.28 ];
$vpr = [ 90.00, 0.00, 0.00 ];
$vpd = 616.09;
$vpf = 22.50;

function brace_key_size(elevation) =
    third_angle_size(brace_size(elevation), top_labels=[1,0,0]);

function distance_to_brace(i) =
    i == 0
    ? 0
    : (brace_key_size(brace_elevations[i-1]).x
       + size_label_height() * 3 // space between
       + distance_to_brace(i - 1));

key([["LEG", 3, third_angle_size(leg_size, top_labels=[1,0,0])],
     ["BRACE",
      str(3, " of each size") ,
      brace_key_size(brace_elevations[0])],
     ["CLAMP", 2, third_angle_size(pipe_clamp_size(), top_labels=[1,0,0])],
     ["PIPE",
      1,
      third_angle_size([pipe_size.z, pipe_size.x, pipe_size.x],
                       top_labels=undef)]]) {
    third_angle(leg_size) {
        leg();
        union() {
            for (i = [0 : len(brace_elevations) - 1]) {
                d = (brace_elevations[i] + brace_profile.z / 2)
                    / sin(leg_angle);
                translate([leg_size.x - d - (leg_size.z / 2) / tan(leg_angle),
                           0,
                           leg_size.z / 2 - size_label_height() * i])
                    size_label(d);
            }
            angle_label(-15, 90, leg_size.z);
        }
        ta_right_side(leg_size.x) {
            size_label(leg_size.y);
            translate([leg_size.y, 0, 0])
                size_label(leg_size.z, rotation=-90);
        }
        ta_top_side(leg_size.z) {
            translate([0, 0, leg_size.y])
                size_label(leg_size.x, over=true);
        }
    }

    for (i = [0 : len(brace_elevations) - 1]) {
        translate([distance_to_brace(i), 0, 0]) {
            e = brace_elevations[i];
            s = brace_size(e);
            third_angle(s) {
                brace(e);
                size_label(brace_bolt_hole_position(s).x);
                ta_right_side(s.x) {
                    size_label(brace_profile.y);
                    translate([brace_profile.y, 0, 0])
                        size_label(brace_profile.z, rotation=-90);
                }
                ta_top_side(brace_profile.z) {
                    translate([0, 0, brace_profile.y]) {
                        size_label(s.x, over=true);
                        angle_label(30, -90, brace_profile.y);
                    }
                }
            }
        }
    }

    third_angle(pipe_clamp_size()) {
        translate(scale([0.5, 0.5, 0], pipe_clamp_size()))
            pipe_clamp_block();
        union() {
            size_label(pipe_clamp_size().x);
        }
        ta_right_side(pipe_clamp_size().x) {
            size_label(pipe_clamp_size().x);
            translate([pipe_clamp_size().x, 0, 0])
                size_label(pipe_clamp_size().z, rotation=-90);
        }
        ta_top_side(pipe_clamp_size().z) {
            translate([(pipe_clamp_size().x - pipe_size.x) / 2,
                       0,
                       pipe_clamp_size().y])
                size_label(pipe_size.x, over=true);
            translate([pipe_clamp_size().x,
                       0,
                       (pipe_clamp_size().y - pipe_size.x) / 2
                       - clamp_bolt_diameter])
                size_label(pipe_size.x + clamp_bolt_diameter, rotation=-90);
        }
    }

    third_angle([pipe_size.z, pipe_size.x, pipe_size.x],
                top_labels=undef) {
        translate([0, pipe_size.x / 2, pipe_size.x / 2])
            rotate([0, 90, 0])
            pipe();
        union() {
            size_label(pipe_size.z);
        }
        ta_right_side(pipe_size.z) {
            size_label(pipe_size.x);
            translate([0, 0, pipe_size.x])
                size_label(pipe_size.y, over=true);
        }
    }
}

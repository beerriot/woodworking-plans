// Key to the wood parts, plus the pipe because it's on the same scale.
//cmdline: --projection=o --imgsize=4096,2048
include <../common/echo-camera-arg.scad>

use <signal-tower.scad>
include <params.scad>

use <../common/labeling.scad>
use <../common/math_funcs.scad>

$vpt = [ 65.20, 0.00, 29.20 ];
$vpr = [ 90.00, 0.00, 0.00 ];
$vpd = 260.59;
$vpf = 22.50;

key([["LEG", 3, third_angle_size(leg_size)],
     ["BRACE",
      3 * len(brace_elevations),
      third_angle_size(brace_size(brace_elevations[0]))],
     ["CLAMP", 2, third_angle_size(pipe_clamp_size())],
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

    third_angle(brace_size(brace_elevations[0])) {
        brace(brace_elevations[0]);
        union() {}
        ta_right_side(brace_size(brace_elevations[0]).x) { }
        ta_top_side(brace_profile.z) { }
    }

    third_angle(pipe_clamp_size()) {
        translate(scale([0.5, 0.5, 0], pipe_clamp_size()))
            pipe_clamp_block();
        union() {}
        ta_right_side(pipe_clamp_size().x) {}
        ta_top_side(pipe_clamp_size().z) {}
    }

    third_angle([pipe_size.z, pipe_size.x, pipe_size.x],
                top_labels=undef) {
        translate([0, pipe_size.x / 2, pipe_size.x / 2])
            rotate([0, 90, 0])
            pipe();
        union() {}
        ta_right_side(pipe_size.z) {}
    }
}

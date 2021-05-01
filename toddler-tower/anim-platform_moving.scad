//cmdline: --animate=60 --imgsize=1024,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>

include <params.scad>

$vpt = [ 23.17, 28.80, 46.13 ];
$vpr = [ 57.80, 0.00, 139.80 ];
$vpd = 268.57;

// Animation timeline:
// major sections [start, end]
anim_platform_start = 0;
anim_step_start = 0.5;

// subsections [relative start, duration]
anim_remove_bolts = [0, 0.1];
anim_slide_out = [0.1, 0.1];
anim_change_height = [0.2, 0.1];
anim_slide_in = [0.3, 0.1];
anim_replace_bolts = [0.4, 0.1];

// Compute the amount of `distance` that should be applied based on
// the current time. This animation cycles: wait, out, wait, in.
//
// Starting at `$t = base_t+out_t[0]`, larger percentages of
// `distance` will be returned until 100% of `distance` is returned at
// `$t = base_t+out_t[0]+out_t[1]`.
//
// 100% of distance will continue to be returned until `$t =
// base_t+in_t[0]`, at which point smaller percentages will be
// returned, until 0 is returned at `$t = base_t+in_t[0]+in_t[1]`.
function out_in_anim(base_t, out_t, in_t, distance) =
    let (out_rel_t = $t - base_t - out_t[0],
         in_rel_t = $t - base_t - in_t[0])
    ((out_rel_t < 0) || (in_rel_t > in_t[1]))
    ? 0                                    // before out, or after in
    : ((out_rel_t < out_t[1])
       ? (distance * out_rel_t / out_t[1]) // moving out
       : ((in_rel_t > 0)
          ? (distance * (in_t[1] - in_rel_t) / in_t[1])  // moving in
          : distance));               // moved out, not yet moving in

// Do an out-in animation based on the slide_out and slide_in times.
function slide_anim(base_t, distance) =
    out_in_anim(base_t, anim_slide_out, anim_slide_in, distance);

// Do an out-in animation based on the remove_bolt and replace_bolt
// times.
function bolt_anim(base_t) =
    out_in_anim(base_t,
                anim_remove_bolts,
                anim_replace_bolts,
                bolt_length() * 1.25);

// Compute the amount of distance between `height1` and `height2` that
// should be applied, based on the current time. This animation is
// does not cycle: wait, move, wait. It is also based only on
// `anim_change_height`.
//
// Abbreviating: `ach` == `anim_change_height`
//               `diff` = `height2 - height1`
//
// Starting at `$t = base_t+ach[0]`, larger percentages of `diff` are
// returned, until 100% is returned at `$t = base_t+ach[0]+ach[1]`.
function height_anim(base_t, height1, height2) =
    let (height_diff = height2 - height1,
         rel_t = $t - base_t - anim_change_height[0])
    (rel_t < 0)
    ? 0                                 // before anim_change_height
    : ((rel_t < anim_change_height[1])
       ? (height_diff * rel_t / anim_change_height[1]) // during ach
       : height_diff);                   // after anim_change_height

// Basically `assembly_platform` from the main model, with adjustments
// for animation.
module animated_platform(start, end) {
    // heights of platform and bolts all change together
    translate([0, 0, height_anim(anim_platform_start,
                                 platform_heights[start],
                                 platform_heights[end])])
        place_platform_at(start) {
        translate([thickness - recess_depth(),
                   slide_anim(anim_platform_start, platform_depth * 1.25),
                   0])
            platform();

        translate([-bolt_anim(anim_platform_start), 0, thickness / 2])
            rotate([0, 90, 0])
            platform_bolts();
        translate([width + bolt_anim(anim_platform_start), 0, thickness / 2])
            rotate([0, -90, 0])
            platform_bolts();
    }
}

// Basically `assembly_front_step` from the main model, with adjustments
// for animation.
module animated_front_step(start, end) {
    translate([0,
               // bolts have to adjust for inset, just like the step.
               // this is "height_anim" because it doesn't cycle, but
               // notice that it's applied to the Y axis
               height_anim(anim_step_start,
                           front_step_inset(front_step_heights[start]),
                           front_step_inset(front_step_heights[end])),
               // actually adjusting the height here
               height_anim(anim_step_start,
                           front_step_heights[start],
                           front_step_heights[end])])
        place_front_step_at(start) {
        translate([thickness - recess_depth(),
                   slide_anim(anim_step_start, -front_step_depth() * 1.25),
                   0])
            front_step();

        translate([-bolt_anim(anim_step_start), 0, thickness / 2])
            rotate([0, 90, 0])
            front_step_bolts();
        translate([width + bolt_anim(anim_step_start), 0, thickness / 2])
            rotate([0, -90, 0])
            front_step_bolts();
    }
}

assembly_side_panels();
assembly_cross_members();

platform_height_start = max(0, len(platform_heights) - 2);
platform_height_end = max(0, platform_height_start - 1);
animated_platform(platform_height_start, platform_height_end);

front_step_height_start = 0;
front_step_height_end = min(1, len(front_step_heights) - 1);
animated_front_step(front_step_height_start, front_step_height_end);

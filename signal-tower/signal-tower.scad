// A tower on top of which I will mount my satellite dish.

use <../common/common.scad>
use <../common/labeling.scad>
use <../common/math_funcs.scad>

include <params.scad>

$fs = 0.1;
$fa = 5;

// The bottom end of the pipe is even with the bottom side of the
// highest brace.
function assembled_height() =
    pipe_size.z + max(brace_elevations);

// This does not include the clamp on the top.
function wood_tower_height() =
    (leg_size.x - (leg_size.z / tan(leg_angle))) * sin(leg_angle);

// How far the outside edge of the bottom of the leg is from the
// center of the pipe.
function wood_tower_base_radius() =
    (pipe_size.x / 2
     + wood_tower_height() / tan(leg_angle)
     + leg_size.z / sin(leg_angle));

// The amount of brace length that extends on the side of the pipe
// opposite the leg.
//
//     here
//  \\|----|
//   \\=============________
//    \\  (p)  |      leg
//     \\      +------------
function brace_length_past_pipe() =
    // distance from pipe-leg radius to other brace
    (leg_size.y / 2) / cos(30)
    // distance from pipe-brace radius to pipe-leg radius
    + (brace_profile.y + leg_size.y / 2) * tan(30);

// Total length of the brace.
function brace_length(at_height) =
    // leg span without pipe shift, because shift actually makes the
    // triangle taller, though we're concerned with the end of the
    // legs as the height
    (wood_tower_height() - at_height) / tan(leg_angle)
    // account for pipe shift in leg span
    + pipe_size.x / 2
    // width of leg at angle
    + leg_size.z / sin(leg_angle)
    + brace_length_past_pipe();

function brace_size(at_height) =
    [brace_length(at_height), 0, 0] + brace_profile;

module leg() {
    color(leg_color)
        translate([pipe_size.x / 2, -leg_size.y / 2, wood_tower_height()])
        rotate([0, leg_angle, 0])
        difference() {
        cube(leg_size);

        rotate([0, -leg_angle, 0])
            translate(-err([1,1,0]))
            cube(leg_size + err([0,2,0]));

        translate([wood_tower_height() / sin(leg_angle), 0, 0])
            rotate([0, -leg_angle, 0])
            translate([0, 0, -leg_size.z] - err([1,1,0]))
            cube(leg_size + err([0,2,0]));

        for (h = brace_elevations)
            translate([(wood_tower_height() / sin(leg_angle))
                       - (h / sin(leg_angle)
                          - (leg_size.z / 2) / tan(leg_angle)
                          + (brace_profile.z / 2) / sin(leg_angle)),
                       0,
                       leg_size.z / 2])
                bolt_hole();
    }
}

module pipe() {
    color(pipe_color)
        difference() {
        cylinder(h=pipe_size.z, d=pipe_size.x);

        translate(err([0, 0, -1]))
            cylinder(h=(pipe_size + err([0, 0, 2])).z, d=pipe_size.y);
    }
}

module brace(at_height) {
    size = brace_size(at_height);

    color(brace_color)
    translate([-brace_length_past_pipe(), leg_size.y / 2, at_height])
    difference() {
        cube(size);

        translate([size.x, 0, 0])
            rotate([0, leg_angle, 0])
            translate([-size.x, 0, 0] - err([0, 1, 0]))
            cube(size + err([1, 2, 0]));


        translate([0, size.y, 0])
            rotate([0, 0, -60])
            translate([0, -size.y, 0] - err([1, 0, 1]))
            cube(size + err([0, 1, 2]));

        translate([size.x
                   - (size.y / 2) * sin(leg_angle)
                   - (leg_size.z / 2) / sin(leg_angle),
                   0,
                   size.z / 2])
        bolt_hole();
    }
}

module bolt_hole() {
    translate(-err([0,1,0]))
        rotate([-90, 0, 0])
        cylinder(d=leg_bolt_diameter, h=(leg_size + err([0,2,0])).y);
}

function leg_bolt_length() = leg_size.y + brace_size.y * 1.5;

module leg_bolt() {
    bolt(leg_bolt_length(),
         leg_bolt_diameter,
         head_thickness=leg_bolt_diameter,
         head_size=leg_bolt_head_size,
         thread_length=brace_profile.y / 2,
         thread_pitch=10,
         thread_depth=bolt_diameter * 0.05);
}

module leg_washer() {
    washer(od=leg_bolt_diameter * 3,
           id=leg_bolt_diameter,
           thickness=leg_bolt_diameter * 0.05);
}

module leg_nut() {
    nut(thickness=leg_bolt_diameter,
        size=leg_bolt_head_size,
        id=leg_bolt_diameter,
        thread_pitch=10,
        thread_depth=leg_bolt_diameter * 0.05);
}

module pipe_clamp() {
    color(clamp_color)
        translate(scale([-0.5, -0.5, 0], clamp_layer_size))
        difference() {
        // made of three layers of material ...
        cube(scale([1, 1, 3], clamp_layer_size));

        // ... with a bolt hole
        translate(scale([0.5, 0, 1.5], clamp_layer_size) - err([0, 1, 0]))
            rotate([-90, 0, 0])
            cylinder(h=clamp_layer_size.y / 2, d=clamp_bolt_diameter);

        // ... and a pipe hole
        translate(scale([0.5, 0.5, 0], clamp_layer_size) - err([0, 0, 1]))
            cylinder(h=(clamp_layer_size * 3 + err([0, 0, 2])).z,
                     d=pipe_size.x);
    }
}

// ASSEMBLY

module tower_leg() {
    leg();
    for (h = brace_elevations) {
        brace(h);
    }
}

module tower() {
    tower_leg();
    rotate([0, 0, 120]) tower_leg();
    rotate([0, 0, -120]) tower_leg();
    translate([0, 0, max(brace_elevations)]) pipe();
}

module ground() {
    color("#cccc0099")
        translate([0, 0, -1])
        cylinder(r=wood_tower_base_radius() * 3, h=1);
}

tower();
//ground();

size_label(wood_tower_base_radius(), over=true);
translate([wood_tower_base_radius() - leg_size.z / sin(leg_angle), -leg_size.y, 0]) {
    angle_label(leg_angle, 180 - leg_angle, wood_tower_height() / 15);
}
size_label(wood_tower_height(), rotation=-90);
size_label(wood_tower_height() + pipe_size.z
           - (wood_tower_height() - max(brace_elevations)),
          rotation=-90,
          over=true);
translate([wood_tower_base_radius(), 0, 0]) {
    size_label(leg_size.x, rotation=-(180-leg_angle));
}
for (h = brace_elevations) {
    translate([-brace_length_past_pipe(),
               leg_size.y / 2 + brace_profile.y,
               h]) {
        size_label(brace_length(h));
        translate([brace_profile.y * tan(30), 0, 0])
            size_label(leg_size.z / tan(30));


        translate([0, 0, brace_profile.z / 2])
            size_label(brace_size(h).x
                      - (brace_profile.y / 2) * sin(leg_angle)
                      - (leg_size.z / 2) / sin(leg_angle));

    }
    translate([wood_tower_base_radius(), 0, 0]) {
        size_label((h + brace_profile.z / 2) / sin(leg_angle),
                   rotation=-(180-leg_angle));
    }
 }

translate([0, 0, max(brace_elevations) + brace_profile.z])
pipe_clamp();

rotate([0, 0, 15])
translate([0, 0, wood_tower_height()])
pipe_clamp();

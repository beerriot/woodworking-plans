// A tower on top of which I will mount my satellite dish.

use <../common/common.scad>
use <../common/labeling.scad>
use <../common/math_funcs.scad>
use <../common/hardware.scad>

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

// COMPONENTS

$use_finish_colors = false;

module wood_diagram_color(diagram_color) {
    color($use_finish_colors ? finish_wood_color : diagram_color) children();
}

module metal_diagram_color(diagram_color) {
    color($use_finish_colors ? finish_metal_color : diagram_color) children();
}

module leg() {
    wood_diagram_color(leg_color)
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
    metal_diagram_color(pipe_color)
        difference() {
        cylinder(h=pipe_size.z, d=pipe_size.x);

        translate(err([0, 0, -1]))
            cylinder(h=(pipe_size + err([0, 0, 2])).z, d=pipe_size.y);
    }
}

function brace_bolt_hole_position(size) =
    [size.x
     - (size.y / 2) * sin(leg_angle)
     - (leg_size.z / 2) / sin(leg_angle),
     0,
     size.z / 2];

module brace(at_height) {
    size = brace_size(at_height);

    wood_diagram_color(brace_color)
    difference() {
        cube(size);

        translate([0, size.y, 0])
            rotate([0, 0, -60])
            translate([0, -size.y, 0] - err([1, 0, 1]))
            cube(size + err([0, 1, 2]));

        translate(brace_bolt_hole_position(size))
            bolt_hole();
    }
}

function brace_hanger_panel_size() =
    // slightly less tall than the braces, each side half as wide as tall
    [brace_profile.z * 0.45, hanger_thickness, brace_profile.z * 0.9];

function brace_hanger_screw_positions() =
    let (panel_size = brace_hanger_panel_size())
    [scale([0.3, 0, 0.2], panel_size),
     scale([0.6, 0, 0.4], panel_size),
     scale([0.3, 0, 0.6], panel_size),
     scale([0.6, 0, 0.8], panel_size)];

module brace_hanger() {
    module brace_hanger_side() {
        difference() {
            cube(brace_hanger_panel_size());

            for (p = brace_hanger_screw_positions()) {
                translate(p-err([0, 1, 0]))
                    rotate([-90, 0, 0])
                    cylinder(h=(brace_profile + err([0, 0, 2])).y,
                             d=hanger_screw_size.y);
            }
        }
    }

    metal_diagram_color(hanger_color) {
        brace_hanger_side();
        rotate([0, 0, -60]) mirror([1, 0, 0]) brace_hanger_side();
    }
}

module brace_hanger_screw() {
    deck_screw(hanger_screw_size.z,
               hanger_screw_size.y,
               hanger_screw_size.x);
}

module brace_hanger_screws() {
    module one_side() {
        for (p = brace_hanger_screw_positions()) {
            translate(p)
                rotate([85, 0, 0])
                translate([0, 0, -hanger_thickness*3])
                brace_hanger_screw();
        }
    }

    metal_diagram_color(hardware_color) {
        one_side();
        rotate([0, 0, -60]) mirror([1, 0, 0]) one_side();
    }
}

module bolt_hole() {
    translate(-err([0,1,0]))
        rotate([-90, 0, 0])
        cylinder(d=leg_bolt_diameter, h=(leg_size + err([0,2,0])).y);
}

function leg_bolt_length() = leg_size.y + brace_profile.y * 1.5;

module leg_bolt() {
    bolt(leg_bolt_length(),
         leg_bolt_diameter,
         head_thickness=leg_bolt_diameter,
         head_size=leg_bolt_head_size,
         thread_length=brace_profile.y / 2,
         thread_pitch=10,
         thread_depth=leg_bolt_diameter * 0.05);
}

// [OD, ID, thickness]
function leg_washer_size() =
    [leg_bolt_diameter * 3, leg_bolt_diameter, leg_bolt_diameter * 0.05];

module leg_washer() {
    size = leg_washer_size();
    washer(od=size.x, id=size.y, thickness=size.z);
}

module leg_nut() {
    nut(thickness=leg_bolt_diameter,
        size=leg_bolt_head_size,
        id=leg_bolt_diameter,
        thread_pitch=10,
        thread_depth=leg_bolt_diameter * 0.05);
}

// made of three layers of material
function pipe_clamp_size() = scale([1, 1, 3], clamp_layer_size);

module pipe_clamp_block() {
    wood_diagram_color(clamp_color)
        translate(scale([-0.5, -0.5, 0], clamp_layer_size))
        difference() {
        cube(pipe_clamp_size());

        // ... with a bolt hole
        translate(scale([0.5, 0, 1.5], clamp_layer_size) - err([0, 1, 0]))
            rotate([-90, 0, 0])
            cylinder(h=clamp_layer_size.y / 2, d=clamp_t_nut_diameter);

        // ... and a pipe hole
        translate(scale([0.5, 0.5, 0], clamp_layer_size) - err([0, 0, 1]))
            cylinder(h=(clamp_layer_size * 3 + err([0, 0, 2])).z,
                     d=pipe_size.x);

        // ... with extra room for the T-nut
        translate(scale([0.5, 0.5, 0], clamp_layer_size)
                  - [clamp_t_nut_diameter * 1.5,
                     pipe_size.x / 2 + clamp_bolt_diameter,
                     0]
                  - err([0, 0, 1]))
            cube([clamp_t_nut_diameter * 3,
                  pipe_size.x / 2 + clamp_bolt_diameter,
                  clamp_layer_size.z * 3]
                 + err([0, 0, 2]));
    }
}

module pipe_clamp_t_nut() {
    metal_diagram_color(hardware_color)
    t_nut(clamp_bolt_diameter,
          clamp_t_nut_diameter,
          clamp_bolt_diameter * 2,
          10);
}

function pipe_clamp_bolt_length() = clamp_layer_size.y / 2;

module pipe_clamp_bolt() {
    metal_diagram_color(hardware_color)
    bolt(pipe_clamp_bolt_length(),
         clamp_bolt_diameter,
         head_thickness=clamp_bolt_diameter,
         head_size=clamp_bolt_head_size,
         thread_length=pipe_clamp_bolt_length(),
         thread_pitch=10,
         thread_depth=clamp_bolt_diameter * 0.05);
}

// ASSEMBLY

module pipe_clamp() {
    pipe_clamp_block();

    translate(scale([0, 0, 1.5], clamp_layer_size)
              - [0,
                 pipe_size.x / 2 + clamp_bolt_diameter,
                 0])
        rotate([90, 0, 0])
        pipe_clamp_t_nut();

    translate(scale([0, 0, 1.5], clamp_layer_size)
              + [0, -(pipe_size.x / 2 + pipe_clamp_bolt_length()), 0])
        rotate([-90, 0, 0])
        pipe_clamp_bolt();
}

module leg_bolt_with_nut_and_washers() {
    metal_diagram_color(hardware_color)
        rotate([90, 0, 0]) {
        translate([0, 0, -leg_washer_size().z]) {
            leg_bolt();
            leg_washer();
        }
        translate([0, 0, leg_size.y + brace_profile.y]) {
            leg_washer();
            translate([0, 0, leg_washer_size().z]) leg_nut();
        }
    }
}

module brace_with_hanger_and_bolt(elevation) {
    translate([-brace_length_past_pipe(), leg_size.y / 2, elevation])
        brace(elevation);

    translate([-brace_length_past_pipe(),
               leg_size.y / 2 + brace_profile.y,
               elevation + brace_profile.z * 0.05]) {
        brace_hanger();
        brace_hanger_screws();
    }

    bolt_base_position = [0, leg_size.y / 2 + brace_profile.y, elevation]
        + brace_bolt_hole_position(brace_size(elevation))
        - [brace_length_past_pipe(), 0, 0];
    translate(bolt_base_position)
        leg_bolt_with_nut_and_washers();
}

module tower_leg() {
    translate([pipe_size.x / 2, -leg_size.y / 2, wood_tower_height()])
        rotate([0, leg_angle, 0])
        leg();
    for (i = [0 : len(brace_elevations) - 1]) {
        if (i % 2 == 0) {
            mirror([0, 1, 0])
                brace_with_hanger_and_bolt(brace_elevations[i]);
        } else {
            brace_with_hanger_and_bolt(brace_elevations[i]);
        }
    }
}

module tower() {
    tower_leg();
    rotate([0, 0, 120]) tower_leg();
    rotate([0, 0, -120]) tower_leg();
    translate([0, 0, max(brace_elevations)]) pipe();

    rotate([0, 0, 60])
    translate([0, 0, max(brace_elevations) + brace_profile.z])
        pipe_clamp();

    rotate([0, 0, 30])
        translate([0, 0, wood_tower_height()])
        pipe_clamp();
}

module ground() {
    color(ground_color)
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

// A tower on top of which I will mount my satellite dish.

use <../common/labeling.scad>

include <params.scad>

$fs = 0.1;
$fa = 5;

// "- leg thickness" is a simplification here. If measured to a point,
// the amount of the leg inside the radius is (thickness /
// cos(angle)). But, since we don't actually want the point out there
// splintering off anyway, we'll just cut it square at leg_thickness
// from the inner edge, and that also saves us more complicated math.
function leg_angle() =
    atan(wood_tower_height
         // distance from the outside of the pipe to the inside of the leg
         / (wood_tower_base_radius - pipe_diameter / 2 - leg_thickness));
function leg_length() =
    // length from height to ground
    wood_tower_height / sin(leg_angle())
    // length for corners above height and ground
    + 2 * leg_thickness / tan(leg_angle());
function leg_size() = [leg_length(), leg_thickness, leg_width];

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
    (leg_size().y / 2) / cos(30)
    // distance from pipe-brace radius to pipe-leg radius
    + (brace_thickness + leg_size().y / 2) * tan(30);

// Total length of the brace.
function brace_length(at_height) =
    // leg span without pipe shift, because shift actually makes the
    // triangle taller, though we're concerned with the end of the
    // legs as the height
    (wood_tower_height - at_height) / tan(leg_angle())
    // account for pipe shift in leg span
    + pipe_diameter / 2
    // width of leg at angle
    + leg_size().z / sin(leg_angle())
    + brace_length_past_pipe();

function brace_size(at_height) =
    [brace_length(at_height), brace_thickness, brace_height];

function err(vec) = 0.01 * vec;

module leg() {
    color(leg_color)
        translate([pipe_diameter / 2, -leg_size().y / 2, wood_tower_height])
        rotate([0, leg_angle(), 0])
        difference() {
        cube(leg_size());

        rotate([0, -leg_angle(), 0])
            translate(-err([1,1,0]))
            cube(leg_size() + err([0,2,0]));

        translate([wood_tower_height / sin(leg_angle()), 0, 0]) {
            rotate([0, -leg_angle(), 0])
                translate([0, 0, -leg_size().z] - err([1,1,0]))
                cube(leg_size() + err([0,2,0]));

            // clip the toe that was ignored by the radius calculation
            translate([leg_size().z / cos(leg_angle()), 0, 0])
                rotate([0, -(leg_angle() + 90), 0])
                translate([0, 0, -leg_size().z] - err([1,1,0]))
                cube(leg_size() + err([0,2,0]));
        }
    }
}

module pipe() {
    color(pipe_color) cylinder(h=pipe_length, d=pipe_diameter);
}

module brace(at_height) {
    size = brace_size(at_height);

    color(brace_color)
    translate([-brace_length_past_pipe(), leg_size().y / 2, at_height])
    difference() {
        cube(size);

        translate([size.x, 0, 0])
            rotate([0, leg_angle(), 0])
            translate([-size.x, 0, 0] - err([0, 1, 0]))
            cube(size + err([1, 2, 0]));


        translate([0, size.y, 0])
            rotate([0, 0, -60])
            translate([0, -size.y, 0] - err([1, 0, 1]))
            cube(size + err([0, 1, 2]));
    }
}

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
    translate([0, 0, brace_elevations[len(brace_elevations) - 1]]) pipe();
}

module ground() {
    color("#cccc0099")
        translate([0, 0, -1])
        cylinder(r=wood_tower_base_radius * 3, h=1);
}

tower();
//ground();

sizeLabel(wood_tower_base_radius, over=true);
translate([wood_tower_base_radius - leg_size().z / sin(leg_angle()), -leg_size().y, 0]) {
    angleLabel(leg_angle(), 180 - leg_angle(), wood_tower_height / 15);
}
sizeLabel(wood_tower_height, rotation=-90);
sizeLabel(wood_tower_height + pipe_length
          - (wood_tower_height - brace_elevations[len(brace_elevations) - 1]),
          rotation=-90,
          over=true);
translate([wood_tower_base_radius, 0, 0]) {
    sizeLabel(leg_size().x, rotation=-(180-leg_angle()));
}
for (h = brace_elevations)
    translate([-brace_length_past_pipe(),
               leg_size().y / 2 + brace_thickness,
               h])
        sizeLabel(brace_length(h));

// Labeling library
include <common.scad>
use <math_funcs.scad>

$fs = 0.1;

default_marker_radius = 1.5;

function size_label_height(marker_radius=default_marker_radius) =
    marker_radius * 2;

module size_label(distance,
                  over=false,
                  marker_radius=default_marker_radius,
                  line_radius=0.1,
                  color="grey",
                  sigfig=2,
                  rotation=0) {
    module size_end() {
        cylinder(0.1, marker_radius, marker_radius * 0.75);
    }

    rounded = is_num(distance)
        ? round(pow(10, sigfig) * distance) / pow(10, sigfig)
        : distance;

    rotate([0, rotation, 0])
        translate([0, 0, (over ? 1 : -1) * marker_radius + 0.01])
        color(color) {

        rotate([0, 90, 0]) {
            size_end();
            // translated in Z, because this is unrotated, and
            // cylinder height is in Z
            translate([0, 0, distance]) mirror([0, 0, 1]) size_end();
            cylinder(distance, r=line_radius);
        }

        assert(abs(rotation) >= 0 && abs(rotation) <= 360,
               str("size_label rotation must be between 0 and 360 (found ",
                   rotation, ")"));

        // center text left-to-right at low angles, but move it to the
        // side above 30º
        halign = (abs(rotation) <= 30 ||
                  (abs(rotation) >= 150 && abs(rotation) <= 210) ||
                  abs(rotation) >= 330)
            ? "center"
            : (((rotation < -30 && rotation > -150) ||
                (rotation > 210 && rotation < 330))
               ? (over ? "right" : "left")
               : (over ? "left" : "right"));

        // move the text below or above at low angles, but put it
        // right in the middle above 45º
        valign = (abs(rotation) <= 45 || abs(rotation) >= 315)
            ? (over ? "bottom" : "top")
            : ((abs(rotation) >= 135 && abs(rotation) <= 225)
               ? (over ? "top" : "bottom")
               : "center");

        translate([distance / 2, 0, (over ? 1 : -1) * marker_radius / 2])
            rotate([90, -rotation, 0])
            text(str(rounded),
                 halign=halign,
                 valign=valign,
                 size=marker_radius);
    }
}

//TODO: currently only works for 0 <= |angle| <= 180
module angle_label(angle, reference_angle, size, color="grey") {
    assert((-180 <= angle) && (angle <= 180));
    color(color) {
        rotate([0, -reference_angle, 0]) {
            cube([size, 0.1, 0.1]);
            difference() {
                rotate([90, 0, 0])
                    cylinder(h=0.1, r=size * 2 / 3, center=true);
                rotate([90, 0, 0])
                    cylinder(h=0.12, r=size * 2 / 3 - 0.1, center=true);
                translate([-size, -0.06, (angle >= 0) ? -size * 2 : 0])
                    cube([size * 2, 0.12, size * 2]);
                rotate([0, -angle, 0])
                    translate([-size, -0.06, (angle >= 0) ? 0 : -size])
                    cube([size * 2, 0.12, size]);
            }
        }
        translate([cos(reference_angle + angle / 2) * size * 7 / 8,
                   0,
                   sin(reference_angle + angle / 2) * size * 7 / 8])
            rotate([90, 0, 0])
            text(str(abs(angle), "º"),
                 halign="center",
                 valign="center",
                 size=sin(abs(angle)) * size * 0.45);
    }
}

// Each element in children_info should be a vector of three elements:
//    [
//     name,  // String to show next to the component
//     count, // Number to show in parentheses next to name
//     size   // vec3 of the size of the component
//    ]
module key(children_info=[],
           text_color="black",
           spacing=size_label_height() / 2) {
    function name(i) = children_info[i][0];
    function count(i) = children_info[i][1];
    function size(i) = children_info[i][2];

    assert(len(children_info) == $children,
           str("Length of key children (", $children,
               ") and info (", len(children_info), ") do not match."));

    // midpoints for each child
    heights = [ for(i = 0, h = 0;
                    i < $children;
                    h = h + size(i).z + spacing, i = i + 1) h];

    text_size = 0.5 * min([for (i = [0 : $children - 1]) size(i).z]);

    for (i = [0 : len(children_info) - 1]) {
        translate([0, 0, heights[i]]) {
            translate([-text_size / 2, 0, size(i).z / 2])
                rotate([90, 0, 0])
                color(text_color)
                text(count(i) == undef
                     ? name(i)
                     : str(name(i), " (", count(i), ")"),
                     halign="right",
                     valign="center",
                     size=text_size);
            children(i);
        }
    }
}

// Create a third-angle projection of the piece, when viewed from the
// front (looking in the positive-Y direction). The object to be
// viewed should be entirely in the +X+Y+Z octant.
//
// The first arguments is the rough size of the object. The next three
// are vec3 denoting [N, E, S] how many size_labels are stacked on that
// side. These are used to determine how far to move each projected
// view.
//
// The module expects either 2, 3 or 4 children. They are:
//    1: The object to be projected
//    2: Additional elements (e.g. sizes) to be shown in the front
//       projection
//    3: Additional elements for the right-side projection. If
//       omitted, no right projection or top projection will be
//       created (use an empty node, and set right_labels=undef if you
//       want a top view but not a right view).
//    4: Additional elements for the top projection. If omitted, no
//       top projection will be created.
//
// All additional elements should be created around the object,
// oriented such that they would display correctly if the view were
// simply rotated. This module will rotate them to face forward as it
// creates each projection view.  The ta_right_side and ta_top_side
// modules do the correct translation, to allow you to specify
// positioning along X and Z axes, as they will be seen.
//
// The resulting third-angle projection should be viewed in Orthogonal
// mode.
ta_default_front_labels = [0,0,1];
ta_default_right_labels = [0,1,1];
ta_default_top_labels = [0,1,0];
ta_default_spacing = 1;
module third_angle(size,
                   front_labels=ta_default_front_labels,
                   right_labels=ta_default_right_labels,
                   top_labels=ta_default_top_labels,
                   spacing=ta_default_spacing) {
    assert($children >= 2 && $children <=4,
           str("third_angle requires 2 - 4 children ",
               "- object, front, [right, top] - but passed ", $children))

        // make the bottom of the bottom front label sit at zero
        translate([0,
                   0,
                   size_label_height()
                   * (front_labels == undef ? 0 : front_labels[2])]) {
        // Front view
        children([0:1]);

        // Right view
        front_right_label_space = size_label_height()
            * (front_labels == undef ? 0 : front_labels[1]);

        if ($children > 2 && right_labels != undef)
            translate([spacing + size.x + front_right_label_space, 0, 0])
                rotate([0, 0, -90])
                translate([-size.x, 0, 0])
                children([0,2]);

        // Top view
        front_top_label_space = size_label_height() *
            ((front_labels == undef ? 0 : front_labels[0]) +
             (top_labels == undef ? 0 : top_labels[2]));
        if ($children > 3 && top_labels != undef)
            translate([0, 0, spacing + size.z + front_top_label_space])
                rotate([90, 0, 0])
                translate([0, 0, -size.z])
                children([0,3]);
    }
}

module ta_right_side(x_size) {
    translate([x_size, 0, 0]) rotate([0, 0, 90]) children();
}

module ta_top_side(z_size) {
    translate([0, 0, z_size]) rotate([-90, 0, 0]) children();
}

function third_angle_size(size,
                          front_labels=ta_default_front_labels,
                          right_labels=ta_default_right_labels,
                          top_labels=ta_default_top_labels,
                          spacing=ta_default_spacing) =
    [size.x
     + spacing
     + (right_labels == undef ? 0 : size.y)
     + (size_label_height()
        * (front_labels[1] + (right_labels == undef ? 0 : right_labels[1]))),

     max(size.x, size.y, size.z),

     size.z
     + spacing
     + (top_labels == undef ? 0 : size.y)
     + (size_label_height()
        * (front_labels[0] + front_labels[2]
           + (top_labels == undef ? 0 : (top_labels[0] + top_labels[2]))))];

module elision(size=[1,1,1]) {
    difference() {
        cube(size+[2,2,2]*$err, center=true);

        translate(scale(size, [-0.5, 0, -0.1]))
            rotate([90, 0, 0])
            scale([2,1,1])
            cylinder(size.y+4*$err, d=size.z * 0.2, center=true);
        translate(scale(size, [0.5, 0, 0.1]))
            rotate([90, 0, 0])
            scale([2,1,1])
            cylinder(size.y+4*$err, d=size.z * 0.2, center=true);
    }
    translate(scale(size, [-0.5, 0, 0.1]))
        rotate([90, 0, 0])
        scale([2,1,1])
        cylinder(size.y+4*$err, d=size.z * 0.2, center=true);
    translate(scale(size, [0.5, 0, -0.1]))
        rotate([90, 0, 0])
        scale([2,1,1])
        cylinder(size.y+4*$err, d=size.z * 0.2, center=true);
}

// test
size_label(50);

key([["foo", 1, [1,1,1]],
     ["bar", 2, [2,2,2]]]) {
    cube([1,1,1]);
    cube([2,2,2]);
}

translate([0, 0, 50]) third_angle([5, 2, 3]) {
    cube([5, 2, 3]);

    size_label(5);

    ta_right_side(5) {
        size_label(2);
        translate([2, 0]) rotate([0, -90, 0]) size_label(3);
    }

}

translate([0, 0, 70]) third_angle([5, 2, 3], top_labels=[1, 0, 1]) {
    difference() {
        cube([5, 2, 3]);
        translate([2.5, 2, -0.01]) cylinder(3.02, r=1);
    }

    size_label(5);

    ta_right_side(5) {
        translate([0, 0, 3]) size_label(2, over=true);
        translate([2, 0]) rotate([0, -90, 0]) size_label(3);
    }

    ta_top_side(3) {
        translate([1.5, 0, 2]) size_label(2, over=true);
        size_label(5);
    }
}

translate([10, 0]) angle_label(30, 0, 20);
translate([10, 0]) angle_label(30, 30, 20);
translate([10, 0]) angle_label(30, -30, 20);
translate([10, 0]) angle_label(15, -90, 20);

translate([50, 0, 40]) {
    rotate([90, 0, 0]) text("under, neg", size=2, halign="right");
    translate([0, 0, 15])
        rotate([90, 0, 0])
        text("under, pos", size=2, halign="right");
    translate([0, 0, 30])
        rotate([90, 0, 0])
        text("over, neg", size=2, halign="right");
    translate([0, 0, 45])
        rotate([90, 0, 0])
        text("over, pos", size=2, halign="right");

    for (a = [0 : 15 : 360]) {
        translate([a+5, 0, -10])
            rotate([90, 0, 0])
            text(str(a), size=2, halign="center", valign="top");
        translate([a, 0, 0]) size_label(10, over=false, rotation=-a);
        translate([a, 0, 15]) size_label(10, over=false, rotation=a);
        translate([a, 0, 30]) size_label(10, over=true, rotation=-a);
        translate([a, 0, 45]) size_label(10, over=true, rotation=a);
    }
}

// Screws and such

use <labeling.scad>
use <common.scad>

$fs = 0.1;
$fa = 5;

module threads(length, pitch, depth, id) {
    linear_extrude(height=length, convexity=10, twist=-360 * length * pitch)
        translate([id / 2, 0, 0])
        square([depth, 0.1]);
}

deck_screw_head_diameter = 0.6;
module deck_screw(length,
                  diameter=0.3,
                  head_diameter=deck_screw_head_diameter) {
    difference() {
        cylinder(h=0.3, d1=deck_screw_head_diameter, d2=diameter);
        cube([0.3, 0.1, 0.15], center=true);
        cube([0.1, 0.3, 0.15], center=true);
    }
    translate([0, 0, 0.29]) cylinder(h=length-0.3, d=diameter);
    translate([0, 0, length-0.02]) cylinder(h=0.3, d1=diameter, d2=0.01);
    translate([0, 0, 0.3]) threads(length - 0.3, 6, 0.05, diameter);
}

function finish_washer_height() = 0.3;
module finish_washer() {
    difference() {
        cylinder(h=finish_washer_height(),
                 d1=deck_screw_head_diameter + 0.1,
                 d2=deck_screw_head_diameter + 0.3);

        translate(-err([0, 0, 1]))
            cylinder(h=finish_washer_height() + err([0, 0, 2]).z,
                     d1=deck_screw_head_diameter,
                     d2=0.3);
    }
}

module washer(od, id, thickness) {
    difference() {
        cylinder(h=thickness, d=od);

        translate(-err([0, 0, 1]))
            cylinder(h=thickness + err([0, 0, 2]).z, d=id);
    }
}

module hex_bolt(diameter, length, head_diameter, head_thickness, hex_size) {
    cylinder(h=length, d=diameter);
    translate([0, 0, -head_thickness] - err([0, 0, 1]))
        difference() {
        cylinder(h=head_thickness, d=head_diameter);

        translate(-err([0, 0, 1]))
            cylinder(h=head_thickness / 2, d=hex_size, $fn=6);
    }

    threads(length, 10, 0.05, diameter);
}

// `shaft_length` gives the total length of the bolt after the head.
// The unthreaded portion of the shaft will have a length of
// `shaft_length - thread_length`. That is, to make a fully-threaded
// bolt set `shaft_length` and `thread_lenth` to the same value.
module bolt(shaft_length,
            shaft_diameter,
            head_thickness,
            head_size,
            thread_length,
            thread_pitch,
            thread_depth) {
    // head of the bolt
    translate([0, 0, -head_thickness] - err([0, 0, 1]))
        cylinder(h=head_thickness, d=head_size, $fn=6);

    // unthreaded shaft
    cylinder(h=shaft_length - thread_length, d=shaft_diameter);

    // threaded shaft
    translate([0, 0, shaft_length - thread_length - 0.1]) {
        cylinder(h=thread_length, d=shaft_diameter - (thread_depth * 2));
        threads(thread_length,
                thread_pitch,
                thread_depth,
                shaft_diameter - (thread_depth * 2));
    }
}

module nut(thickness, size, id, thread_pitch, thread_depth) {
    difference() {
        cylinder(h=thickness, d=size, $fn=6);

        translate(-err([0, 0, 1]))
            cylinder(h=thickness + err([0, 0, 2]).z, d=id);
    }
    threads(thickness, thread_pitch, thread_depth, id - thread_depth * 2);
}

module threaded_insert(id, od, depth, od_pitch=3, od_thread_depth=0.2) {
    difference() {
        cylinder(h=depth, d=od);

        translate(-err([0, 0, 1]))
            cylinder(h=depth + err([0, 0, 2]).z, d=id);
    }
    threads(depth, od_pitch, od_thread_depth, od);
}

module t_nut(id, od, depth, pitch) {
    module tooth(err=0) {
        length = od / 2;
        thickness = (od - id) / 2 + err;
        cut_length = length * sqrt(2);

        translate([od * 1.5 - length, 0, 0])
            difference() {
            cube([length, length, thickness]);
            rotate([0, 0, 45])
                translate(-err([1, 0, 1]))
                cube([cut_length, cut_length, thickness] + err([2, 2, 2]));
        }
    }
    translate([0, 0, -(od - id) / 2]) {
        difference() {
            union() {
                cylinder(h=(od - id) / 2, d=od * 3);
                cylinder(h=depth, d=od);
            }

            translate(-err([0, 0, 1]))
                cylinder(h=depth + err([0, 0, 2]).z, d=id);

            translate(-err([0, 0, 1]))
                for (i = [0 : 90 : 270])
                    rotate([0, 0, i])
                        tooth(err([0, 0, 2]).z);
        }
        threads(depth, pitch, id * 0.05, id * 0.90);

        for (i = [0 : 90 : 270])
            rotate([90, 0, i])
                tooth();
    }
}

key([["DECK_SCREW", 1,
      [5, deck_screw_head_diameter, deck_screw_head_diameter]],
     ["FINISH_WASHER", 1,
      [5, deck_screw_head_diameter + 0.3, deck_screw_head_diameter + 0.3]],
     ["HEX_BOLT", 1, [5, 2.5, 2.5]],
     ["BOLT", 1, [5, 1.5, 1.5]],
     ["NUT", 1, [5, 1.5, 1.5]],
     ["WASHER", 1, [5, 1.5, 1.5]],
     ["THREADED_INSERT", 1, [1, 0.6, 0.6]],
     ["T_NUT", 1, [1, 1.5, 1.5]]]) {
    translate([0, deck_screw_head_diameter / 2, deck_screw_head_diameter / 2])
        rotate([0, 90, 0])
        deck_screw(5);
    translate([0,
               (deck_screw_head_diameter + 0.3) / 2,
               (deck_screw_head_diameter + 0.3) / 2])
        rotate([0, 90, 0])
        finish_washer();
    translate([0.15, 1.25, 1.25])
        rotate([0, 90, 0])
        hex_bolt(0.3, 5, 2.5, 0.15, 0.3);
    translate([0.6, 0.75, 0.75])
        rotate([0, 90, 0])
        bolt(4, 0.8, 0.6, 1.5, 1, 10, 0.1);
    translate([0.6, 0.75, 0.75])
        rotate([-90, 0, 0])
        nut(0.6, 1.5, 0.8, 10, 0.1);
    translate([0.6, 0.75, 0.75])
        rotate([-90, 0, 0])
        washer(1.5, 0.8, 0.1);
    translate([0, 0.3, 0.3])
        rotate([0, 90, 0])
        threaded_insert(0.3, 0.6, 1);
    translate([0.6, 0.75, 0.75])
        rotate([-90, 0, 0])
        t_nut(0.6, 0.8, 1, 10);
}

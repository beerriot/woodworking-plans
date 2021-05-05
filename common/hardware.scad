// Screws and such

use <labeling.scad>

$fs = 0.1;
$fa = 5;

module threads(length, pitch, depth, id) {
    linear_extrude(height=length, convexity=10, twist=-360 * length * pitch)
        translate([id / 2, 0, 0])
        square([depth, 0.1]);
}

deck_screw_head_diameter = 0.6;
module deck_screw(length) {
    difference() {
        cylinder(h=0.3, d1=deck_screw_head_diameter, d2=0.3);
        cube([0.3, 0.1, 0.15], center=true);
        cube([0.1, 0.3, 0.15], center=true);
    }
    translate([0, 0, 0.29]) cylinder(h=length-0.3, d=0.3);
    translate([0, 0, length-0.02]) cylinder(h=0.3, d1=0.3, d2=0.01);
    translate([0, 0, 0.3]) threads(length - 0.3, 6, 0.05, 0.3);
}

function finish_washer_height() = 0.3;
module finish_washer() {
    difference() {
        cylinder(h=finish_washer_height(),
                 d1=deck_screw_head_diameter + 0.1,
                 d2=deck_screw_head_diameter + 0.3);

        translate([0, 0, -0.01])
            cylinder(h=finish_washer_height() + 0.02,
                     d1=deck_screw_head_diameter,
                     d2=0.3);
    }
}

module hex_bolt(diameter, length, head_diameter, head_thickness, hex_size) {
    cylinder(h=length, d=diameter);
    translate([0, 0, -(head_thickness - 0.01)])
        difference() {
        cylinder(h=head_thickness, d=head_diameter);

        translate([0, 0, -0.01])
            cylinder(h=head_thickness / 2, d=hex_size, $fn=6);
    }

    threads(length, 10, 0.05, diameter);
}

module threaded_insert(id, od, depth, od_pitch=3, od_thread_depth=0.2) {
    difference() {
        cylinder(h=depth, d=od);

        translate([0, 0, -0.01]) cylinder(h=depth+0.02, d=id);
    }
    threads(depth, od_pitch, od_thread_depth, od);
}

key([["DECK_SCREW", 1,
      [5, deck_screw_head_diameter, deck_screw_head_diameter]],
     ["FINISH_WASHER", 1,
      [5, deck_screw_head_diameter + 0.3, deck_screw_head_diameter + 0.3]],
     ["HEX_BOLT", 1, [5, 2.5, 2.5]],
     ["THREADED_INSERT", 1, [1, 0.6, 0.6]]]) {
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
    translate([0, 0.3, 0.3])
        rotate([0, 90, 0])
        threaded_insert(0.3, 0.6, 1);
}

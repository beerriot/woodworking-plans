// Folding Laundy Rack

// TODO: paracord and hooks
// TODO: treat Z as "up", as "front"/"top"/etc. view settings do
// TODO: move lengths to variables
// TODO: parameterize? angles? dowel count?
// TODO: animate open/close?

// finer faceting on small cylinders
$fs = 0.1;

module dowel(length) {
    cylinder(h = length, r = 0.65);
}

module longDowel() {
    color([0.6, 0.6, 1])
    dowel(108);
}

module shortDowel() {
    color([0, 0, 1])
    dowel(104.2);
}

// subtract this from arm & leg
module dowelHole() {
    translate([0,1.9,-0.1]) dowel(4);
}

module leg() {
    color([0.5, 1.0, 0.5])
    translate([0, -1.9, 0])
    difference() {
        cube([141.9, 3.8, 1.9]);
        translate([14,0,0]) dowelHole();
        translate([84,0,0]) dowelHole();
        translate([140,0,0]) dowelHole();
    }
}

module arm() {
    color([0.9, 0.5, 0.8])
    translate([0, -1.9, 0])
    difference() {
        cube([87.8, 3.8, 1.9]);
        translate([1.9, 0, 0]) dowelHole();
        translate([15.9, 0, 0]) dowelHole();
        translate([29.9, 0, 0]) dowelHole();
        translate([43.9, 0, 0]) dowelHole();
        translate([57.9, 0, 0]) dowelHole();
        translate([71.9, 0, 0]) dowelHole();
        translate([85.9, 0, 0]) dowelHole();
    }
}

/*
leg();
translate([0, 5, 0]) arm();
rotate([0, 90, 0]) translate([0, 10, 0]) dowel(108);
rotate([0, 90, 0]) translate([0, 15, 0]) dowel(104.2);
*/

rotate([0, 0, 60]) leg();
translate([84, 0, 1.9]) rotate([0, 0, 120]) leg();
translate([84, 0, 104.2]) rotate([0, 0, 120]) leg();
translate([0, 0, 106.1]) rotate([0, 0, 60]) leg();

// bottom dowels
translate([7, 7 * sqrt(3)]) longDowel();
translate([77, 7 * sqrt(3), 1.9]) shortDowel();

// middle pivot
translate([42, 42 * sqrt(3)]) longDowel();

// top pivots
translate([14, 70 * sqrt(3)]) longDowel();
translate([70, 70 * sqrt(3)]) longDowel();
translate([42, 70 * sqrt(3)]) longDowel();

// left side
translate([-43.9, 70 * sqrt(3), 0]) arm();
translate([-43.9, 70 * sqrt(3), 106.1]) arm();
translate([28, 70 * sqrt(3)]) longDowel();
translate([0, 70 * sqrt(3)]) longDowel();
translate([-14, 70 * sqrt(3)]) longDowel();
translate([-28, 70 * sqrt(3)]) longDowel();
translate([-42, 70 * sqrt(3)]) longDowel();

// right side
translate([40, 70 * sqrt(3), 1.9]) arm();
translate([40, 70 * sqrt(3), 104.2]) arm();
translate([55.9, 70 * sqrt(3), 1.9]) shortDowel();
translate([83.9, 70 * sqrt(3), 1.9]) shortDowel();
translate([97.9, 70 * sqrt(3), 1.9]) shortDowel();
translate([111.9, 70 * sqrt(3), 1.9]) shortDowel();
translate([125.9, 70 * sqrt(3), 1.9]) shortDowel();
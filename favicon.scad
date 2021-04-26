$vpt = [ 5.02, -1.26, -0.48 ];
$vpr = [ 69.70, 0.00, 57.20 ];
$vpd = 17.56;

module lap_joint() {
    difference() {
        cube([5, 0.5, 1]);
        translate([-1, -0.25, -1]) cube([2, 0.5, 3]);
        translate([4, -0.25, -1]) cube([2, 0.5, 3]);
    }
}

color("#cc9900") {
    lap_joint();
    translate([0, 0, -4]) lap_joint();
}

color("#cccc99") translate([0, -0.24, -4]) {
    translate([0, 0.75, -0.01]) rotate([180, -90, 0]) lap_joint();
    translate([4, 0, 0]) rotate([180, -90, 0]) lap_joint();
}

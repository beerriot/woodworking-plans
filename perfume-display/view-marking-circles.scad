// Show how to mark the drilling locations by drawing cricles with a compass.
//cmdline: --projection=o --imgsize=2048,1280
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <perfume-display.scad>

$fs = 0.2;
$fa = 10;

$vpr = [ 0.00, 0.00, 0.00 ];
$vpt = [ 12.46, 8.62, 3.58 ];
$vpd = 73.83;

color(plank_color) {
    plank();
}

positions = vial_positions();
inset = static_border() + dynamic_border();

module wide_row_marks() {
    color("#00ff00") {
        translate([0, -0.05]) cube([plank_size.x, 0.1, 0.1]);

        for (i = [0 : vials_in_row(0) - 1])
            translate([inset.x + (vial_center_distance() * i) - 0.05, -0.25])
                cube([0.1, 0.5, 0.1]);
    }
}

module circle(conflict) {
    difference() {
        translate([0, 0, -conflict * 0.01])
            cylinder(r=vial_center_distance() + 0.05,
                     h=0.1 + (conflict * 0.02));
        cylinder(r=vial_center_distance() - 0.05,
                 h=1 + (conflict * 0.02),
                 center=true);
    }
}

translate([0, 0, plank_size.z]) {
    color("#00ff00") {
        rotate([-90, 0, 0])
            size_label(inset.x);

        rotate([-90, 0, 0])
            size_label(inset.y, rotation=-90, over=true);
        translate([0, inset.y - 0.05, 0]) wide_row_marks();
    }

    translate([0, 0, -0.01])
        intersection() {
        color("#00ccff")
            for (i = [0 : len(positions) - 1])
                let (p = positions[i])
                    translate(inset + [p[0].x, p[0].y, 0]) {
                    circle(i);
                }

        translate([vial_center_distance() / 2, vial_center_distance() / 2])
            cube([plank_size.x - vial_center_distance(),
                  plank_size.y - vial_center_distance(),
                  0.99]);
    }
}

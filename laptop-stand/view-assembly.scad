// Above and to the side perspective view
//cmdline: --imgsize=2048,1536
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

// nicer curves for laptop demo
$fs = 0.1;
$fa = 5;

$vpr=[ 71.10, 0.00, 50.20 ];
$vpt=[ 16.98, 12.80, 22.60 ];
$vpf=22.50;
$vpd=154.02;

color(finish_color)
assembly();

// demonstration laptop

module roundrect(size, r) {
    hull() {
        translate([r, r, 0]) circle(r);
        translate([size.x-r, r, 0]) circle(r);
        translate([size.x-r, size.y-r, 0]) circle(r);
        translate([r, size.y-r, 0]) circle(r);
    }
}

module roundcube(size, r) {
    linear_extrude(size.z) roundrect(size, r);
}

module laptop() {
    color([1, 1, 1, 0.3])
    roundcube([laptop_case_depth, laptop_case_width, laptop_case_thickness],
              laptop_case_radius);

    color([1, 1, 1, 0.15])
    rotate([0, -(90+tilt), 0])
        roundcube([laptop_case_depth, laptop_case_width,
                   laptop_case_thickness / 2],
                  laptop_case_radius);
}

riser_rotate()
translate([riser_length(), -arm_inset, riser_width])
rotate([0, 90, 0])
laptop();

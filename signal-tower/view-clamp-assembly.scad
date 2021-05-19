// How the braces go together in the middle
//cmdline: --projection=o --imgsize=2048,2048
include <../common/echo-camera-arg.scad>

use <signal-tower.scad>
include <params.scad>

use <../common/labeling.scad>
use <../common/common.scad>

$vpt = [ 12.60, -14.11, 15.94 ];
$vpr = [ 54.60, 0.00, 39.90 ];
$vpd = 118.50;
$vpf = 22.50;

$fs=0.1;
$fa=5;

module arrow() {
    cylinder(h=clamp_layer_size.x, d=clamp_layer_size.z);
    translate([0, 0, clamp_layer_size.x])
    cylinder(h=clamp_layer_size.x / 4,
             d1=2 * clamp_layer_size.z,
             d2=0.01);
}

color(clamp_color) {
    translate([0, 0, 2 * clamp_layer_size.z])
        difference() {
        pipe_clamp_block();
        translate(-(err([1,1,1]) + scale([0.5, 0.5, 0], clamp_layer_size)))
            cube(scale([1,1,2], clamp_layer_size)+err([2,2,1]));
    }

    difference() {
        pipe_clamp_block();
        translate(-(err([1,1,1]) + scale([0.5, 0.5, 0], clamp_layer_size)))
            cube(scale([1,1,1], clamp_layer_size)+err([2,2,1]));
        translate(scale([-0.5, -0.5, 2], clamp_layer_size) + err([-1, -1, 1]))
            cube(scale([1,1,1], clamp_layer_size)+err([2,2,1]));
    }

    translate([0, 0, -2 * clamp_layer_size.z])
        difference() {
        pipe_clamp_block();
        translate(scale([-0.5, -0.5, 1], clamp_layer_size) + err([-1, -1, 1]))
            cube(scale([1,1,2], clamp_layer_size)+err([2,2,1]));
    }
}

color("#00333366") {
translate([clamp_layer_size.x / 3, 0, clamp_layer_size.z * 4.5])
rotate([90, 0, 0])
arrow();
translate([-clamp_layer_size.x / 3, 0, clamp_layer_size.z * 4.5])
rotate([90, 0, 0])
arrow();

translate([0, clamp_layer_size.x / 3, clamp_layer_size.z * 1.5])
rotate([0, 90, 0])
arrow();
translate([0, -clamp_layer_size.x / 3, clamp_layer_size.z * 1.5])
rotate([0, 90, 0])
arrow();

translate([clamp_layer_size.x / 3, 0, -clamp_layer_size.z * 1.5])
rotate([90, 0, 0])
arrow();
translate([-clamp_layer_size.x / 3, 0, -clamp_layer_size.z * 1.5])
rotate([90, 0, 0])
arrow();
}

// Label offsets for drilling holes.
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

color(plankColor) plank();

positions = vialPositions();
inset = staticBorder() + dynamicBorder();

module wideRowMarks() {
    color("#00ff00") {
        translate([0, -0.05]) cube([plankSize.x, 0.1, 0.1]);

    for (i = [0 : vialsInRow(0) - 1])
        translate([inset.x + (vialCenterDistance() * i) - 0.05, -0.25])
            cube([0.1, 0.5, 0.1]);
    }
}

module circle(conflict) {
    difference() {
        translate([0, 0, -conflict * 0.01])
            cylinder(r=vialCenterDistance() + 0.05,
                     h=0.1 + (conflict * 0.02));
        cylinder(r=vialCenterDistance() - 0.05,
                 h=1 + (conflict * 0.02),
                 center=true);
    }
}

translate([0, 0, plankSize.z]) {
    color("#00ff00") {
        rotate([-90, 0, 0])
            sizeLabel(inset.x);
        //        translate([inset.x - 0.05, 0]) cube([0.1, plankSize.y, 0.1]);

        rotate([-90, 0, 0])
            sizeLabel(inset.y, rotation=-90, over=true);
        translate([0, inset.y - 0.05, 0]) wideRowMarks();
    }

    translate([0, 0, -0.01])
    intersection() {
        color("#00ccff")
            for (i = [0 : len(positions) - 1])
                let (p = positions[i])
                    translate(inset + [p[0].x, p[0].y, 0]) {
                    circle(i);
                }

        translate([vialCenterDistance() / 2, vialCenterDistance() / 2])
            cube([plankSize.x - vialCenterDistance(),
                  plankSize.y - vialCenterDistance(),
                  0.99]);
    }
}

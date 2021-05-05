// Label offsets for drilling holes.
//cmdline: --projection=o --imgsize=2048,1280
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <perfume-display.scad>

$vpr = [ 0.00, 0.00, 0.00 ];
$vpt = [ 12.46, 8.62, 3.58 ];
$vpd = 73.83;

color(plankColor) plank();

inset = staticBorder() + dynamicBorder();

module wideRowMarks() {
    color("#00ff00") {
        translate([0, -0.05]) cube([plankSize.x, 0.1, 0.1]);

    for (i = [0 : vialsInRow(0) - 1])
        translate([inset.x + (vialCenterDistance() * i) - 0.05, -0.25])
            cube([0.1, 0.5, 0.1]);
    }
}

translate([0, 0, plankSize.z]) {
    color("#00ff00") {
        rotate([-90, 0, 0])
            size_label(inset.x);
        //        translate([inset.x - 0.05, 0]) cube([0.1, plankSize.y, 0.1]);

        rotate([-90, 0, 0])
            size_label(inset.y, rotation=-90, over=true);
        translate([0, inset.y - 0.05, 0]) wideRowMarks();

        translate(inset + [vialCenterDistance() , 0, 0])
            rotate([-90, 0, 0])
            size_label(vialCenterDistance());
    }

    intersection() {
        color("#00ccff")
            for (i = [0 : vialsInRow(0) -1])
                translate([inset.x + (vialCenterDistance() * i), inset.y]) {
                    rotate([0, 0, 60])
                        translate([0, -0.05, 0])
                        cube([max(plankSize), 0.1, 0.1]);
                    rotate([0, 0, 120])
                        translate([0, -0.05, 0])
                        cube([max(plankSize), 0.1, 0.1]);
                }

        translate([0, 0, -plankSize.z / 2]) plank();
    }

    color("#ff99ff")
        for (i = [2 : intMaxVials().y - 1])
            translate(inset + rowOffset(i) + [-0.5, -0.05, 0])
                cube([plankSize.x - (inset.x + rowOffset(i).x) * 2 + 1,
                      0.1,
                      0.1]);

}

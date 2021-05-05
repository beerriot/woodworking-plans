// Label offsets for drilling holes.
//cmdline: --projection=o --imgsize=2048,1280
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <perfume-display.scad>

$vpr = [ 0.00, 0.00, 0.00 ];
$vpt = [ 12.46, 6.62, 3.58 ];
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

module narrowRowMarks() {
    color("#0099ff") {
        translate([0, -0.05]) cube([plankSize.x, 0.1, 0.1]);

    for (i = [0 : vialsInRow(1) - 1])
        translate([inset.x + rowOffset(1).x +
                   (vialCenterDistance() * i) - 0.05,
                   -0.25])
            cube([0.1, 0.5, 0.1]);
    }
}

translate([0, 0, plankSize.z]) {
    color("#00ff00") {
        rotate([-90, 0, 0])
            size_label(inset.x);

        rotate([-90, 0, 0])
            size_label(inset.y, rotation=-90, over=true);
        translate([0, inset.y])
            for (i = [0 : intMaxVials().y - 1])
                if (i % 2 == 0)
                    translate([0, interRowSpace() * i]) {
                        wideRowMarks();
                        if (i > 0)
                            translate([0, -interRowSpace()])
                                rotate([-90, 0, 0])
                                size_label(interRowSpace(),
                                          rotation=-90,
                                          over=true);
                    }
    }

    color("#00ccff") {
        translate([0, -size_label_height()]) {
            rotate([-90, 0, 0])
                size_label((inset + rowOffset(1)).x);
            translate([(inset + rowOffset(1)).x - 0.05, 0])
                cube([0.1,
                      (staticBorder() + dynamicBorder() + rowOffset(1)).y +
                      size_label_height(),
                      0.1]);
        }
        translate([0, inset.y]) {
            rotate([-90, 0, 0])
                size_label(rowOffset(1).y, rotation=-90, over=true);
            for (i = [0 : intMaxVials().y - 1])
                if (i % 2 == 1)
                    translate([0, interRowSpace() * i]) {
                        narrowRowMarks();
                        if (i > 0)
                            translate([0, -interRowSpace()])
                                rotate([-90, 0, 0])
                                size_label(interRowSpace(),
                                          rotation=-90,
                                          over=true);
                    }
        }
    }

    color("#ff99ff") {
        translate(inset + [vialCenterDistance() , 0, 0])
            rotate([-90, 0, 0])
            size_label(vialCenterDistance());
    }

}

// Label offsets for drilling holes.
//cmdline: --projection=o --imgsize=2048,1280
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <perfume-display.scad>

$vpr = [ 0.00, 0.00, 0.00 ];
$vpt = [ 12.46, 6.62, 3.58 ];
$vpd = 73.83;

assembly();
fillHolesForOrthographic();

inset = staticBorder() + dynamicBorder() + rowOffset(0);

translate([0, 0, plankSize.z]) {
    color("#00ff00") {
        rotate([-90, 0, 0])
            size_label(inset.x);
        translate([inset.x - 0.05, 0]) cube([0.1, plankSize.y, 0.1]);

        rotate([-90, 0, 0])
            size_label(inset.y, rotation=-90, over=true);
        translate([0, inset.y - 0.05, 0]) cube([plankSize.x, 0.1, 0.1]);
    }

    color("#0099ff") {
        translate([0, -size_label_height()]) {
            rotate([-90, 0, 0])
                size_label((inset + rowOffset(1)).x);

            translate([(inset + rowOffset(1)).x - 0.05, 0])
                cube([0.1, plankSize.y + size_label_height(), 0.1]);
        }
        translate([-size_label_height(), inset.y]) {
            rotate([-90, 0, 0])
                size_label(rowOffset(1).y, rotation=-90, over=true);

            translate([0, rowOffset(1).y - 0.05])
                cube([plankSize.x + size_label_height(), 0.1, 0.1]);
        }
    }

    color("#ff99ff") {
        translate(inset + [vialCenterDistance() , 0, 0])
            rotate([-90, 0, 0])
            size_label(vialCenterDistance());
    }

}

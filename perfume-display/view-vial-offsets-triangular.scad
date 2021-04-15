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

positions = vialPositions();

inset = staticBorder() + dynamicBorder() + rowOffset(0);

translate([0, 0, plankSize.z]) {
    color("#00ff00") {
        rotate([-90, 0, 0])
            sizeLabel(inset.x);
        translate([inset.x - 0.05, 0]) cube([0.1, plankSize.y, 0.1]);

        rotate([-90, 0, 0])
            sizeLabel(inset.y, rotation=-90, over=true);
        translate([0, inset.y - 0.05, 0]) cube([plankSize.x, 0.1, 0.1]);
    }

    color("#00ccff")
        translate(inset + [vialCenterDistance() , 0, 0]) {
        rotate([-90, 0, 0])
            sizeLabel(vialCenterDistance());
        rotate([-90, 0, 0])
            sizeLabel(vialCenterDistance(), rotation=-60, over=true);

        rotate([-90, 0, 0])
            angleLabel(-60, 60, vialCenterDistance() * 5);
    }
}

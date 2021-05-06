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
fill_holes_for_orthographic();

inset = static_border() + dynamic_border() + row_offset(0);

translate([0, 0, plank_size.z]) {
    color("#00ff00") {
        rotate([-90, 0, 0])
            size_label(inset.x);
        translate([inset.x - 0.05, 0]) cube([0.1, plank_size.y, 0.1]);

        rotate([-90, 0, 0])
            size_label(inset.y, rotation=-90, over=true);
        translate([0, inset.y - 0.05, 0]) cube([plank_size.x, 0.1, 0.1]);
    }

    color("#00ccff")
        translate(inset + [vial_center_distance() , 0, 0]) {
        rotate([-90, 0, 0])
            size_label(vial_center_distance());
        rotate([-90, 0, 0])
            size_label(vial_center_distance(), rotation=-60, over=true);

        rotate([-90, 0, 0])
            angle_label(-60, 60, vial_center_distance() * 5);
    }
}

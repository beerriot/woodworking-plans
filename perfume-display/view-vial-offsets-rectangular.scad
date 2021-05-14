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

    color("#0099ff") {
        translate([0, -size_label_height()]) {
            rotate([-90, 0, 0])
                size_label((inset + row_offset(1)).x);

            translate([(inset + row_offset(1)).x - 0.05, 0])
                cube([0.1, plank_size.y + size_label_height(), 0.1]);
        }
        translate([-size_label_height(), inset.y]) {
            rotate([-90, 0, 0])
                size_label(row_offset(1).y, rotation=-90, over=true);

            translate([0, row_offset(1).y - 0.05])
                cube([plank_size.x + size_label_height(), 0.1, 0.1]);
        }
    }

    color("#ff99ff") {
        translate(inset + [vial_center_distance() , 0, 0])
            rotate([-90, 0, 0])
            size_label(vial_center_distance());
    }

}

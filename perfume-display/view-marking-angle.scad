// Demonstrate how to mark the hole placement using angled lines.
//cmdline: --projection=o --imgsize=2048,1280
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <perfume-display.scad>

$vpr = [ 0.00, 0.00, 0.00 ];
$vpt = [ 12.46, 8.62, 3.58 ];
$vpd = 73.83;

color(plank_color) {
    plank();
}

inset = static_border() + dynamic_border();

module wide_row_marks() {
    color("#00ff00") {
        translate([0, -0.05]) cube([plank_size.x, 0.1, 0.1]);

        for (i = [0 : vials_in_row(0) - 1])
            translate([inset.x + (vial_center_distance() * i) - 0.05, -0.25])
                cube([0.1, 0.5, 0.1]);
    }
}

translate([0, 0, plank_size.z]) {
    color("#00ff00") {
        rotate([-90, 0, 0])
            size_label(inset.x);

        rotate([-90, 0, 0])
            size_label(inset.y, rotation=-90, over=true);
        translate([0, inset.y - 0.05, 0]) wide_row_marks();

        translate(inset + [vial_center_distance() , 0, 0])
            rotate([-90, 0, 0])
            size_label(vial_center_distance());
    }

    intersection() {
        color("#00ccff")
            for (i = [0 : vials_in_row(0) -1])
                translate([inset.x + (vial_center_distance() * i), inset.y]) {
                    rotate([0, 0, 60])
                        translate([0, -0.05, 0])
                        cube([max(plank_size), 0.1, 0.1]);
                    rotate([0, 0, 120])
                        translate([0, -0.05, 0])
                        cube([max(plank_size), 0.1, 0.1]);
                }

        translate([0, 0, -plank_size.z / 2]) plank();
    }

    color("#ff99ff")
        for (i = [2 : int_max_vials().y - 1])
            translate(inset + row_offset(i) + [-0.5, -0.05, 0])
                cube([plank_size.x - (inset.x + row_offset(i).x) * 2 + 1,
                      0.1,
                      0.1]);

}

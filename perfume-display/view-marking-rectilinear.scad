// Show how to mark the drilling locations using square measurement.
//cmdline: --projection=o --imgsize=2048,1280
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <perfume-display.scad>

$vpr = [ 0.00, 0.00, 0.00 ];
$vpt = [ 12.46, 6.62, 3.58 ];
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

module narrow_row_marks() {
    color("#0099ff") {
        translate([0, -0.05]) cube([plank_size.x, 0.1, 0.1]);

        for (i = [0 : vials_in_row(1) - 1])
            translate([inset.x + row_offset(1).x +
                       (vial_center_distance() * i) - 0.05,
                       -0.25])
                cube([0.1, 0.5, 0.1]);
    }
}

translate([0, 0, plank_size.z]) {
    color("#00ff00") {
        rotate([-90, 0, 0])
            size_label(inset.x);

        rotate([-90, 0, 0])
            size_label(inset.y, rotation=-90, over=true);
        translate([0, inset.y])
            for (i = [0 : int_max_vials().y - 1])
                if (i % 2 == 0)
                    translate([0, inter_row_space() * i]) {
                        wide_row_marks();
                        if (i > 0)
                            translate([0, -inter_row_space()])
                                rotate([-90, 0, 0])
                                size_label(inter_row_space(),
                                           rotation=-90,
                                           over=true);
                    }
    }

    color("#00ccff") {
        translate([0, -size_label_height()]) {
            rotate([-90, 0, 0])
                size_label((inset + row_offset(1)).x);
            translate([(inset + row_offset(1)).x - 0.05, 0])
                cube([0.1,
                      (static_border() + dynamic_border() + row_offset(1)).y
                      + size_label_height(),
                      0.1]);
        }
        translate([0, inset.y]) {
            rotate([-90, 0, 0])
                size_label(row_offset(1).y, rotation=-90, over=true);
            for (i = [0 : int_max_vials().y - 1])
                if (i % 2 == 1)
                    translate([0, inter_row_space() * i]) {
                        narrow_row_marks();
                        if (i > 0)
                            translate([0, -inter_row_space()])
                                rotate([-90, 0, 0])
                                size_label(inter_row_space(),
                                           rotation=-90,
                                           over=true);
                    }
        }
    }

    color("#ff99ff") {
        translate(inset + [vial_center_distance(), 0, 0])
            rotate([-90, 0, 0])
            size_label(vial_center_distance());
    }

}

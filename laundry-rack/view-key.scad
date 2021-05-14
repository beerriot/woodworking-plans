// Components Key
//cmdline: --projection=o --imgsize=2048,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 40.51, -137.37, 40.81 ];
$vpf=22.50;
$vpd=285.72;

module long_dowel_key() {
    third_angle([long_dowel_length, dowel_radius() * 2, dowel_radius() * 2]) {
        translate([0, 0, dowel_radius()]) rotate([0, 0, -90]) long_dowel();

        size_label(long_dowel_length);

        ta_right_side(long_dowel_length)
            size_label(dowel_radius() * 2, rotation=-90);
    }
}
function long_dowel_key_size() =
    third_angle_size([long_dowel_length,
                      dowel_radius() * 2,
                      dowel_radius() * 2]);

module short_dowel_key() {
    third_angle([short_dowel_length(),
                 dowel_radius() * 2,
                 dowel_radius() * 2]) {
        translate([0, 0, dowel_radius()]) rotate([0, 0, -90]) short_dowel();

        size_label(short_dowel_length());

        ta_right_side(short_dowel_length())
            size_label(dowel_radius() * 2, rotation=-90);
    }
}
function short_dowel_key_size() =
    third_angle_size([short_dowel_length(),
                      dowel_radius() * 2,
                      dowel_radius() * 2]);

module leg_key() {
    third_angle([leg_length(), square_stock_thickness, square_stock_width],
                front_labels=[1,0,1]) {
        translate([0, 0, square_stock_width / 2]) leg();

        union() {
            size_label(leg_length());
            translate([0, 0, -square_stock_width * 0.25])
                size_label(bottom_leg_dowel_distance());

            translate([0, 0, square_stock_width])
                size_label(middle_leg_dowel_distance(), over=true);
            translate([middle_leg_dowel_distance(), 0, square_stock_width])
                size_label(top_leg_dowel_distance()
                           - middle_leg_dowel_distance(),
                           over=true);
            translate([top_leg_dowel_distance(), 0, square_stock_width])
                size_label(leg_length() - top_leg_dowel_distance(),
                           over=true);
        }

        ta_right_side(leg_length()) {
            size_label(square_stock_thickness);
            translate([square_stock_thickness, 0])
                size_label(square_stock_width, rotation=-90);
        }
    }
}
function leg_key_size() =
    third_angle_size([leg_length(),
                      square_stock_thickness,
                      square_stock_width],
                     front_labels=[1,0,1],
                     top_labels=undef);

module arm_key() {
    third_angle([arm_length(), square_stock_thickness, square_stock_width],
                front_labels=[1,0,1]) {
        translate([0, 0, square_stock_width / 2]) arm();

        union() {
            size_label(arm_length());
            translate([0, 0, square_stock_width])
                size_label(square_stock_width / 2, over=true);
            for (i = [1 : len(arm_dowel_holes()) - 1])
                translate([arm_dowel_holes()[i - 1],
                           0,
                           square_stock_width])
                    size_label(arm_hang_dowel_span(), over=true);
            translate([arm_dowel_holes()[len(arm_dowel_holes()) - 1],
                       0,
                       square_stock_width])
                size_label(square_stock_width / 2, over=true);
        }

        ta_right_side(arm_length()) {
            size_label(square_stock_thickness);
            translate([square_stock_thickness, 0])
                size_label(square_stock_width, rotation=-90);
        }
    }
}
function arm_key_size() =
    third_angle_size([arm_length(),
                      square_stock_thickness,
                      square_stock_width],
                     front_labels=[1,0,1],
                     top_labels=undef);

function paracord_key_length() = round(pivot_vertical_span() * 1.25);
module paracord_key() {
    third_angle([paracord_key_length(), paracord_diameter, paracord_diameter],
                front_labels=[0,0,1]) {
        translate([0, 0, paracord_radius()])
            rotate([0, 90, 0])
            paracord_line(paracord_key_length());

        size_label(round(pivot_vertical_span() * 1.25));
    }
}
function paracord_key_size() =
    third_angle_size([paracord_key_length(),
                      paracord_diameter,
                      paracord_diameter],
                     front_labels=[0,0,1],
                     right_labels=undef,
                     top_labels=undef);

// KEY
module parts_key() {
    key([["LEG", 4, leg_key_size()],
         ["ARM", 4, arm_key_size()],
         ["LONG DOWEL", long_dowel_count(), long_dowel_key_size()],
         ["SHORT DOWEL", short_dowel_count(), short_dowel_key_size()],
         ["PARACORD", 2, paracord_key_size()],
         ["HOOK", 2, [0, 0, dowel_diameter*3]]]) {
        leg_key();
        arm_key();
        long_dowel_key();
        short_dowel_key();
        paracord_key();
        translate([paracord_radius(), 0, dowel_diameter*2])
            rotate([0, -90, 0]) hook();
    }
}

parts_key();

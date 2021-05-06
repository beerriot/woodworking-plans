// Third-angle view of assembly
//cmdline: --projection=o --imgsize=2048,1536
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 103.69, -137.37, 118.04 ];
$vpf=22.50;
$vpd=620.12;

module assembly_key() {
    third_angle([leg_shift() + arm_length(),
                 long_dowel_length * 1.25,
                 hanging_height],
                front_labels=[1, 1, 1],
                top_labels=[0,1,1]) {
        assembly();

        union() {
            // top length
            translate([end_of_left_arm(),
                       0,
                       hanging_height + square_stock_width / 2])
                size_label(arm_length() * 2 - square_stock_width, over=true);

            // hanging height
            translate([end_of_left_arm(), 0])
                size_label(hanging_height, rotation=-90, over=true);

            // paracord length
            translate([leg_shift(), 0, hanging_height - pivot_vertical_span()])
                size_label(pivot_vertical_span(), rotation=-90);

            // bottom length
            size_label(leg_shift() * 2);
        }

        // total depth
        ta_right_side(leg_shift() + arm_length())
            translate([0, 0, hanging_height + square_stock_width / 2])
            size_label(long_dowel_length, over=true);


        ta_top_side(hanging_height + square_stock_width / 2) {
            // long inner dowel length
            translate([end_of_left_arm(), 0, square_stock_thickness])
                size_label(long_dowel_length - square_stock_thickness * 2,
                           over=true,
                           rotation=-90);

            // short inner dowel length
            translate([leg_shift() + arm_length() - square_stock_width / 2,
                       0,
                       square_stock_thickness * 2])
                size_label(short_dowel_length() - square_stock_thickness * 2,
                           rotation=-90);
        }
    }
}

assembly_key();

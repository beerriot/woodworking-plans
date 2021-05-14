// View of where the holes in the leg are drilled.
//cmdline: --projection=o --imgsize=1600,400
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ leg_length() / 2, -leg_length(), 0 ];
$vpf=22.50;
$vpd=leg_length() * 0.65;

$fs = 0.1;

leg();

translate([0, 0, square_stock_width / 2])
    size_label(bottom_leg_dowel_distance(), over=true);

translate([0, 0, square_stock_width / 2 + size_label_height()])
    size_label(middle_leg_dowel_distance(), over=true);
translate([middle_leg_dowel_distance() - 0.1,
           0,
           square_stock_width / 2 + size_label_height() * 0.25 ])
    cube([0.1, 1, size_label_height() * 0.5]);

translate([0, 0, square_stock_width / 2 + size_label_height() * 2])
    size_label(top_leg_dowel_distance(), over=true);
translate([top_leg_dowel_distance() - 0.1,
           0,
           square_stock_width / 2 + size_label_height() * 0.25 ])
    cube([0.1, 1, size_label_height() * 1.5]);

translate([top_leg_dowel_distance(), 0, -square_stock_width / 2])
    size_label(leg_length() - top_leg_dowel_distance(), over=false);

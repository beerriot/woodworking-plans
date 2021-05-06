// View of arm holes
//cmdline: --projection=o --imgsize=800,200
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ arm_length() / 2, -arm_length(), 0 ];
$vpf=22.50;
$vpd=arm_length() * 0.65;

arm();

translate([0, 0, square_stock_width / 2]) size_label(dowel_inset(), over=true);

for (i = [1 : len(arm_dowel_holes()) - 1])
    translate([arm_dowel_holes()[i - 1], 0, square_stock_width / 2])
        size_label(arm_hang_dowel_span(), over=true);

translate([arm_dowel_holes()[len(arm_dowel_holes()) - 1],
           0,
           square_stock_width / 2])
    size_label(dowel_inset(), over=true);

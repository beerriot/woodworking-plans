// View of second inner leg attached
//cmdline: --imgsize=800,600
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 162.50, 56.00, 357.20 ];
$vpt=[ 16.83, 58.80, 64.40 ];
$vpf=22.50;
$vpd=351.91;

legs(include_outer_top=false);
translate([end_of_left_arm(), 0, hanging_height])
    wide_arms(include_top=false, include_pivot=true);
translate([leg_shift() - dowel_inset(), 0, hanging_height]) narrow_arms();

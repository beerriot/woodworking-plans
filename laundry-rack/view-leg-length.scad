// View of a leg blank
//cmdline: --projection=o --imgsize=800,200
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ leg_length() / 2, -leg_length(), 0 ];
$vpf=22.50;
$vpd=leg_length() * 0.65;

leg_blank();
translate([0, 0, -square_stock_width / 2]) size_label(leg_length());

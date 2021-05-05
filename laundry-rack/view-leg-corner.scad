// End-on views of the stock to be used.
//cmdline: --projection=o --imgsize=800,400
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 1.87, -141.90, -1.04 ];
$vpf=22.50;
$vpd=23.32;

$fs = 0.1;

leg();
angle_label(legAngleComplement(), -90, squareStockWidth);
translate([0, 0, squareStockWidth / 2])
    size_label(squareStockWidth / 2, rotation=90);

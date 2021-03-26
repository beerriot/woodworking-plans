// End-on views of the stock to be used.
//cmdline: --projection=o --imgsize=800,400

use <laundry-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 1.87, -141.90, -1.04 ];
$vpf=22.50;
$vpd=23.32;

$fs = 0.1;

leg();
angleLabel(legAngleComplement(), -90, squareStockWidth());
translate([0, 0, squareStockWidth() / 2]) rotate([0, 90, 0]) sizeLabel(squareStockWidth() / 2);
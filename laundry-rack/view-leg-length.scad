// View of a leg blank
//cmdline: --projection=o --imgsize=800,200
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ legLength() / 2, -legLength(), 0 ];
$vpf=22.50;
$vpd=legLength() * 0.65;

legBlank();
translate([0, 0, -squareStockWidth / 2]) size_label(legLength());

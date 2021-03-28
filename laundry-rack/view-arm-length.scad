// View of an arm blank
//cmdline: --projection=o --imgsize=800,200

use <laundry-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ armLength() / 2, -armLength(), 0 ];
$vpf=22.50;
$vpd=armLength() * 0.65;

armBlank();
translate([0, 0, -squareStockWidth() / 2]) sizeLabel(armLength());
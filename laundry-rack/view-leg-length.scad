// End-on views of the stock to be used.
//cmdline: --projection=o --imgsize=800,200

use <laundry-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ legLength() / 2, -legLength(), 0 ];
$vpf=22.50;
$vpd=legLength() * 0.65;

legColor() armLegStock(legLength());
translate([0, 0, -squareStockWidth() / 2]) sizeLabel(legLength());

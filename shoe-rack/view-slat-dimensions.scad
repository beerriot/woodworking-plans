// Just the key
//cmdline: --projection=o --imgsize=800,800
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 3, 0.00, -0.91 ];
$vpf=22.50;
$vpd=17.66;

rotate([0, 0, -90]) slatStock(1);
sizeLabel(slatStockThickness);
translate([slatStockThickness, 0]) sizeLabel(slatStockWidth, rotation=-90);

// Just the key
//cmdline: --projection=o --imgsize=800,800
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 2.28, 0.00, 0.85 ];
$vpf=22.50;
$vpd=28.22;

rotate([0, 0, -90]) endStock(1);
sizeLabel(endStockThickness);
translate([endStockThickness, 0]) sizeLabel(endStockWidth, rotation=-90);

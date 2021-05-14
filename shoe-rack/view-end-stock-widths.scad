// Showing the size of the wood for the ends.
//cmdline: --projection=o --imgsize=800,800
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 2.28, 0.00, 0.85 ];
$vpf=22.50;
$vpd=28.22;

rotate([0, 0, -90]) end_stock(1);
size_label(end_stock_thickness);
translate([end_stock_thickness, 0]) size_label(end_stock_width, rotation=-90);

// Cutting the bottom front corner off the bottom shelf.
//cmdline: --projection=o --imgsize=1000,600
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 15.60, 0.00, 1.98 ];
$vpf=22.50;
$vpd=51.55;

$fa = 1;
$fs = 0.1;

shelf_support(bottom_shelf_mounting_angle(), bottom=true);

translate([0, 0, end_stock_width])
angle_label(-bottom_shelf_mounting_angle(),
            0,
            shelf_depth(bottom_shelf_mounting_angle()) * 0.7,
            color="white");

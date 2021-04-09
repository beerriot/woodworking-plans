// The lap joint assembly
//cmdline: --imgsize=800,600
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 58.50, 0.00, 39.00 ];
$vpt=[ 21.71, 25.15, 12.80 ];
$vpf=22.50;
$vpd=240.87;

rotate([0, 0, -90]) {
    // aligned
    translate([endStockThickness * 2, 0]) {
        rotate([-90, -90, 0]) endFrontBack();
        translate([0, endDepth - endStockWidth]) rotate([-90, -90, 0]) endFrontBack();
    }
    rotate([0, 0, 90]) endTopBottom();
    translate([0, 0, endHeight - endStockWidth])
        rotate([0, 0, 90])
        endTopBottom();



    // assembled
    translate([0, endDepth * 1.5]) end();
}

// View of unpainted dowel ends
//cmdline: --projection=o --imgsize=800,400
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ -7.08, -108.00, 9.74 ];
$vpf=22.50;
$vpd=70.41;

space = dowel_diameter + size_label_height();

module paint() {
    color([0.8, 0.8, 0.8, 0.9]) rotate([0, 0, -90])
        dowel(long_dowel_length, errs=[0.01, 0]);
}

key([["LONG DOWEL", 4, [0, 0, space]],
     ["LONG DOWEL", non_pivot_long_dowel_count(), [0, 0, space]],
     ["SHORT DOWEL", short_dowel_count(), [0, 0, space]]]) {
    translate([0,0,size_label_height()]) {
        translate([0, 0, dowel_radius()]) {
            rotate([0, 0, -90]) long_dowel();
            translate([double_square_stock_thickness(), 0]) paint();
        }
        size_label(double_square_stock_thickness());
    }
    translate([0,0,size_label_height()]) {
        translate([0, 0, dowel_radius()]) {
            rotate([0, 0, -90]) long_dowel();
            translate([square_stock_thickness, 0]) paint();
        }
        size_label(square_stock_thickness);
    }
    translate([0,0,size_label_height()]) {
        translate([0, 0, dowel_radius()]) {
            rotate([0, 0, -90]) short_dowel();
            translate([square_stock_thickness, 0]) paint();
        }
        size_label(square_stock_thickness);
    }
}

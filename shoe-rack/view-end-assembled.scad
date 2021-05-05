// Showing an end assembly prepapred, and glued.
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
    translate([end_stock_thickness * 2, 0]) {
        rotate([-90, -90, 0]) end_front_back();
        translate([0, end_depth - end_stock_width])
            rotate([-90, -90, 0])
            end_front_back();
    }
    rotate([0, 0, 90]) end_top_bottom();
    translate([0, 0, end_height - end_stock_width])
        rotate([0, 0, 90])
        end_top_bottom();

    // assembled
    translate([0, end_depth * 1.5]) end();
}

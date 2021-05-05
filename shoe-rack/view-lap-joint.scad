// The lap joint cut
//cmdline: --projection=o --imgsize=1000,400
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 27.22, 0.00, 1.21 ];
$vpf=22.50;
$vpd=74.72;

translate([0, 0, size_label_height() * 1.5]) {
    rotate([90, 0, 0]) end_front_back();
    translate([0, 0, lap_joint_depth()])
        size_label(lap_joint_depth(), rotation=90);
}

size_label(end_stock_width, over=true);
rotate([-90, 0, 0]) end_top_bottom();

size_label(lap_joint_depth(), rotation=90);

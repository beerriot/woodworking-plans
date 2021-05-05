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
    rotate([90, 0, 0]) endFrontBack();
    translate([0, 0, lapJointDepth()])
        size_label(lapJointDepth(), rotation=90);
}

size_label(endStockWidth, over=true);
rotate([-90, 0, 0]) endTopBottom();

size_label(lapJointDepth(), rotation=90);

// Shelves attached to one end.
//cmdline: --imgsize=1000,1000
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 162.50, 91.70, 79.10 ];
$vpt=[ 39.50, 0.30, 24.61 ];
$vpf=22.50;
$vpd=240.92;

assembly(include_second_end=false);

for (i = [0:len(shelf_heights_and_angles)-1]) {
    translate([(len(shelf_heights_and_angles)-i-1) * end_stock_thickness,
               -i * size_label_height() * 1.2,
               shelf_heights_and_angles[i][0]])
        rotate([0, 90, 0])
        size_label(shelf_heights_and_angles[i][0]);
 }

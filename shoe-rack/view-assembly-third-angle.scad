// Third Angle view of Assembly
//cmdline: --projection=o --imgsize=2048,2048
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 58.59, -204.62, 43.92 ];
$vpf=22.50;
$vpd=325.80;

module assembly_key() {
    third_angle([length, end_depth, end_height]) {
        assembly();

        size_label(length);

        ta_right_side(length) {
            size_label(end_depth);
            translate([end_depth, 0]) size_label(end_height, rotation=-90);
        }

        ta_top_side(end_height) {}
    }
}

assembly_key();

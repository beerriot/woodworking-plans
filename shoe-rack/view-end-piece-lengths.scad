// Lengths of the end assembly components
//cmdline: --projection=o --imgsize=1000,400
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 9.70, 0.00, 7.22 ];
$vpf=22.50;
$vpd=112.59;

module labeled_end_blank(length) {
    translate([0, 0, size_label_height()]) {
        end_stock(length);
        size_label(length);
    }
}

function key_size(length) =
    [length, end_stock_thickness, end_stock_width + size_label_height()];

key([["TOP/BOTTOM", 4, key_size(end_depth)],
     ["FRONT/BACK", 4, key_size(end_height)]]) {
    end_top_bottom_color() labeled_end_blank(end_depth);
    end_front_back_color() labeled_end_blank(end_height);
}

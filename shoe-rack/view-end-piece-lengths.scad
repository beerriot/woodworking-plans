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

module labeledEndBlank(length) {
    translate([0, 0, size_label_height()]) {
        endStock(length);
        size_label(length);
    }
}

function keySize(length) =
    [length, endStockThickness, endStockWidth + size_label_height()];

key([["TOP/BOTTOM", 4, keySize(endDepth)],
     ["FRONT/BACK", 4, keySize(endHeight)]]) {
    endTopBottomColor() labeledEndBlank(endDepth);
    endFrontBackColor() labeledEndBlank(endHeight);
}

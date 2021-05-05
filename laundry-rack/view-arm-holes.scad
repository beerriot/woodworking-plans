// View of arm holes
//cmdline: --projection=o --imgsize=800,200
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ armLength() / 2, -armLength(), 0 ];
$vpf=22.50;
$vpd=armLength() * 0.65;

arm();

translate([0, 0, squareStockWidth / 2]) size_label(dowelInset(), over=true);

for (i = [1 : len(armDowelHoles()) - 1])
    translate([armDowelHoles()[i - 1], 0, squareStockWidth / 2])
        size_label(armHangDowelSpan(), over=true);

translate([armDowelHoles()[len(armDowelHoles()) - 1], 0, squareStockWidth / 2])
    size_label(dowelInset(), over=true);

// View of where the holes in the leg are drilled.
//cmdline: --projection=o --imgsize=1600,400
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ legLength() / 2, -legLength(), 0 ];
$vpf=22.50;
$vpd=legLength() * 0.65;

$fs = 0.1;

leg();

translate([0, 0, squareStockWidth / 2])
    size_label(bottomLegDowelDistance(), over=true);

translate([0, 0, squareStockWidth / 2 + size_label_height()])
    size_label(middleLegDowelDistance(), over=true);
translate([middleLegDowelDistance() - 0.1,
           0,
           squareStockWidth / 2 + size_label_height() * 0.25 ])
    cube([0.1, 1, size_label_height() * 0.5]);
    
translate([0, 0, squareStockWidth / 2 + size_label_height() * 2])
    size_label(topLegDowelDistance(), over=true);
translate([topLegDowelDistance() - 0.1,
           0,
           squareStockWidth / 2 + size_label_height() * 0.25 ])
    cube([0.1, 1, size_label_height() * 1.5]);
    
translate([topLegDowelDistance(), 0, -squareStockWidth / 2])
    size_label(legLength() - topLegDowelDistance(), over=false);

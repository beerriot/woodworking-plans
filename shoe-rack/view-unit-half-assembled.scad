// The lap joint assembly
//cmdline: --imgsize=1000,1000
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 162.50, 91.70, 79.10 ];
$vpt=[ 39.50, 0.30, 24.61 ];
$vpf=22.50;
$vpd=240.92;

assembly(includeSecondEnd=false);

for (i = [0:len(shelfHeightsAndAngles)-1]) {
    translate([(len(shelfHeightsAndAngles)-i-1) * endStockThickness,
               -i * sizeLabelHeight() * 1.2,
               shelfHeightsAndAngles[i][0]])
        rotate([0, 90, 0])
        sizeLabel(shelfHeightsAndAngles[i][0]);
 }

/*
  // This is an off-angle view. Was it better/worse?
$vpr=[ 100.20, 29.40, 83.30 ];
$vpt=[ 41.35, 16.05, 20.31 ];
$vpf=22.50;
$vpd=243.84;

for (i = [0:len(shelfHeightsAndAngles)-1]) {
    translate([0, -i * sizeLabelHeight() * 1.2, 0])
        rotate([0, 0, 90])
        sizeLabel(shelfHeightsAndAngles[i][0], rotation=-90, over=true);
 }
*/

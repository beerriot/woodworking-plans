// The lap joint assembly
//cmdline: --projection=o --imgsize=1000,600
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 15.60, 0.00, 1.98 ];
$vpf=22.50;
$vpd=51.55;

$fa = 1;
$fs = 0.1;

shelfSupport(bottomShelfMountingAngle(), bottom=true);

translate([0, 0, endStockWidth])
angle_label(-bottomShelfMountingAngle(),
           0,
           shelfDepth(bottomShelfMountingAngle()) * 0.7,
           color="white");

// Example sizeLabel
//cmdline: --projection=o --imgsize=400,200
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

$vpt=[ 4.90, 24.90, 1.76 ];
$vpr=[ 90.00, 0.00, 0.00 ];
$vpd=27.52;
$vpf=22.50;

$fs = 0.1;

angleLabel(20, 0, 10);

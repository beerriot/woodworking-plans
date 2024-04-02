//cmdline: --imgsize=850,750
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

use <../common/labeling.scad>

$vpr=[ 66.40, 0.00, 308.00 ];
$vpt=[ 15.40, 12.55, 9.60 ];
$vpf=22.50;
$vpd=97.03;

assembly();

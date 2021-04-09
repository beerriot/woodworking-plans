// The lap joint assembly
//cmdline: --imgsize=1000,1000
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 162.50, 91.70, 79.10 ];
$vpt=[ 40.65, 0.43, 24.60 ];
$vpf=22.50;
$vpd=237.92;

assembly();

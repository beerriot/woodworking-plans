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

assembly();

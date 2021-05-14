// Attaching the center support to a shelf.
//cmdline: --imgsize=1000,600
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 67.60, 0.00, 24.30 ];
$vpt=[ 34.81, 30.98, -4.37 ];
$vpf=22.50;
$vpd=163.39;

shelf(shelf_heights_and_angles[0][1],
      include_front_slat=false);

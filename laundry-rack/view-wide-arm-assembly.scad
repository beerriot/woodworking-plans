// View of partially-assembled wide arms
//cmdline: --projection=o --imgsize=800,800
include <../common/echo-camera-arg.scad>

use <laundry-rack.scad>
use <../common/labeling.scad>

$vpr=[ 0.00, 0.00, 0.00 ];
$vpt=[ 43.02, 54.01, 9.74 ];
$vpf=22.50;
$vpd=277.15;

wide_arms(include_top=false, include_pivot=false);

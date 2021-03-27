// View of legs of one side assembled
//cmdline: --imgsize=800,800

use <laundry-rack.scad>
use <../common/labeling.scad>

$vpr=[ 162.50, 56.00, 357.20 ];
$vpt=[ 32.29, 61.72, 39.65 ];
$vpf=22.50;
$vpd=340.36;

legs(includeTop=false);
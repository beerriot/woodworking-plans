// View of legs of one side assembled
//cmdline: --imgsize=800,600
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 162.50, 56.00, 357.20 ];
$vpt=[ 16.83, 58.80, 64.40 ];
$vpf=22.50;
$vpd=351.91;

legs(includeInnerTop=false, includeOuterTop=false);
translate([endOfLeftArm(), 0, hangingHeight])
    wideArms(includeTop=false, includePivot=true);

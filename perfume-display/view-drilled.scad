// Label offsets for drilling holes.
//cmdline: --projection=o --imgsize=2048,1280
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <perfume-display.scad>

$vpr = [ 0.00, 0.00, 0.00 ];
$vpt = [ 12.78, 10.39, 12.22 ];
$vpd = 60.33;

assembly(chamfer=false, groove=false);
fillHolesForOrthographic();

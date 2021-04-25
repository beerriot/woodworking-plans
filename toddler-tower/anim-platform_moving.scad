//cmdline: --animate=60 --imgsize=1024,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>

include <params.scad>

$vpt = [ 23.17, 28.80, 46.13 ];
$vpr = [ 57.80, 0.00, 139.80 ];
$vpd = 268.57;

assembly(0, max(0, len(platform_heights) - 2),
         front_step_position2=1, platform_position2=1);

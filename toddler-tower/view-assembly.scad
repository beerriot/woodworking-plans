//cmdline: --imgsize=2048,2048
include <../common/echo-camera-arg.scad>

use <toddler-tower.scad>

$vpt = [ 24.34, 38.87, 36.31 ];
$vpr = [ 57.80, 0.00, 40.40 ];
$vpd = 321.82;

assembly(use_finish_colors=true);

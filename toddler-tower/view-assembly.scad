//cmdline: --imgsize=2048,1536
include <../common/echo-camera-arg.scad>

use <toddler-tower.scad>

$vpt = [ 16.55, 32.24, 36.31 ];
$vpr = [ 57.80, 0.00, 40.40 ];
$vpd = 321.82;

assembly(use_finish_colors=true);

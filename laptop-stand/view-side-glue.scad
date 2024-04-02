//cmdline: --imgsize=800,750
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

$vpr=[ 90.90, 0.00, 359.10 ];
$vpt=[ 15.48, 3.21, 12.84 ];
$vpf=22.50;
$vpd=86.87;

side(flush_cleat_tongue=false, fancy_edges=false);

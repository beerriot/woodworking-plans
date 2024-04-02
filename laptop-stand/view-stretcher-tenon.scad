//cmdline: --imgsize=1024,720
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

$vpr=[ 70.40, 0.00, 315.00 ];
$vpt=[ 19.05, 10.81, -2.96 ];
$vpf=22.50;
$vpd=54.08;

stretcher();
color([0.5, 0.5, 0.5, 0.25])
render()
stretcher_tenon_negative(-1);

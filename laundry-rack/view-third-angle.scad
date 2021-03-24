// Third-angle view of assembly
//cmdline: --projection=o --imgsize=2048,1536

use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 103.69, -137.37, 118.04 ];
$vpf=22.50;
$vpd=620.12;

assembly(includeLabels=true);

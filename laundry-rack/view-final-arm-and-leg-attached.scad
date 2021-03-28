// View of second inner leg attached
//cmdline: --imgsize=800,600

use <laundry-rack.scad>
use <../common/labeling.scad>

$vpr=[ 162.50, 56.00, 357.20 ];
$vpt=[ 16.83, 58.80, 64.40 ];
$vpf=22.50;
$vpd=351.91;

legs();
translate([endOfLeftArm(), 0, hangingHeight()]) wideArms();
translate([legShift() - dowelInset(), 0, hangingHeight()]) narrowArms();
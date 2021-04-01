// View of dowel lengths
//cmdline: --projection=o --imgsize=800,200
include <../common/echo-camera-arg.scad>

use <laundry-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ longDowelLength() / 2, -longDowelLength(), 0 ];
$vpf=22.50;
$vpd=longDowelLength() * 0.65;

rotate([0, 0, -90]) longDowel();
translate([0, 0, -dowelRadius()]) sizeLabel(longDowelLength());

translate([(longDowelLength() - shortDowelLength()) / 2, 0, sizeLabelHeight()*2]) {
    rotate([0, 0, -90]) shortDowel();
    translate([0, 0, -dowelRadius()]) sizeLabel(shortDowelLength());
}

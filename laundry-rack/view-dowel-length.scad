// View of dowel lengths
//cmdline: --projection=o --imgsize=800,200
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ longDowelLength / 2, -longDowelLength, 0 ];
$vpf=22.50;
$vpd=longDowelLength * 0.65;

rotate([0, 0, -90]) longDowel();
translate([0, 0, -dowelRadius()]) size_label(longDowelLength);

translate([(longDowelLength - shortDowelLength()) / 2,
           0,
           size_label_height()*2]) {
    rotate([0, 0, -90]) shortDowel();
    translate([0, 0, -dowelRadius()]) size_label(shortDowelLength());
}

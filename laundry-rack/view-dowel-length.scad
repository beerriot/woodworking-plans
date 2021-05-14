// View of dowel lengths
//cmdline: --projection=o --imgsize=800,200
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ long_dowel_length / 2, -long_dowel_length, 0 ];
$vpf=22.50;
$vpd=long_dowel_length * 0.65;

rotate([0, 0, -90]) long_dowel();
translate([0, 0, -dowel_radius()]) size_label(long_dowel_length);

translate([(long_dowel_length - short_dowel_length()) / 2,
           0,
           size_label_height() * 2]) {
    rotate([0, 0, -90]) short_dowel();
    translate([0, 0, -dowel_radius()]) size_label(short_dowel_length());
}

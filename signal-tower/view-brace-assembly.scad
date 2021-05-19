// How the braces go together in the middle
//cmdline: --projection=o --imgsize=2048,2048
include <../common/echo-camera-arg.scad>

use <signal-tower.scad>
include <params.scad>

use <../common/labeling.scad>

$vpt = [ -0.16, -1.91, 30.34 ];
$vpr = [ 0.00, 0.00, 0.00 ];
$vpd = 114.80;
$vpf = 22.50;

brace_with_hanger_and_bolt(brace_elevations[0]);
rotate([0, 0, 120]) brace_with_hanger_and_bolt(brace_elevations[0]);
rotate([0, 0, -120]) brace_with_hanger_and_bolt(brace_elevations[0]);

translate([brace_profile.y * tan(30) - brace_length_past_pipe(),
           leg_size.y / 2,
           brace_elevations[0] + brace_profile.z])
rotate([-90, 0, 0])
size_label(leg_size.z / tan(30), over=true);

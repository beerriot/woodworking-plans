//cmdline: --imgsize=1024,640
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

$vpr=[ 88.10, 0.00, 23.60 ];
$vpt=[ 15.59, 3.58, 6.00 ];
$vpf=22.50;
$vpd=54.08;

arm(cut_grooves=false, cut_taper=false);

translate([0, 0, arm_width + wood_thickness * 2])
arm(cut_grooves=false, cut_taper=false);

translate([arm_length() + wood_thickness, 0, 0])
cleat_view_arm_cleat();

translate([arm_length() - cleat_base_depth(),
           0,
           arm_width + wood_thickness])
rotate([0, 90, 0])
color([0.5, 0.5, 0.5, 0.25])
cylinder((cleat_base_depth() + wood_thickness) * 2, 0.05, 0.05);

module cleat_view_arm_cleat() {
    color(cleat_color)
        stock(cleat_base_depth(), (arm_width + wood_thickness) * 2);
}

//cmdline: --imgsize=1024,600
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

use <../common/labeling.scad>

$vpr=[ 90.90, 0.00, 4.00 ];
$vpt=[ -4.67, 2.31, 6.71 ];
$vpf=22.50;
$vpd=60.50;

double_cleat(separate=false);

translate([0, 0, -cleat_base_depth() * 1.1])
rotate([90, 0, 0])
color([0.5, 0.5, 0.5, 0.25])
text("a", size=cleat_base_depth());

translate([-(arm_length() + wood_thickness), 0, 0])
arm();

translate([-wood_thickness * 0.95, 0, arm_width])
rotate([0, 90, 0])
guide(cleat_base_depth() + wood_thickness * 0.95);

translate([-arm_length() + riser_width - wood_thickness * 0.95, 0, 0])
rotate([0, 90, 0])
guide(arm_length() - riser_width + wood_thickness * 0.95);


translate([cleat_base_depth() + wood_thickness, cleat_base_depth(), 0])
rotate([0, 0, -90])
double_cleat(separate=true);

translate([cleat_base_depth() + wood_thickness * 2.1,
           0,
           arm_width + wood_thickness / 2])
rotate([90, 0, 0])
color([0.5, 0.5, 0.5, 0.25])
text("b", size=cleat_base_depth());

$kerf = 0.3;

module double_cleat(separate=true) {
    cleat(cut_taper=false, cut_fancy_edge=false);

    translate([0, 0, (arm_width + wood_thickness) * 2 + $kerf])
        mirror([0, 0, 1])
        cleat(cut_taper=false, cut_fancy_edge=false);

    if (!separate) {
        translate([0, 0, wood_thickness + arm_width])
            color(cleat_color)
            cube([cleat_base_depth(), wood_thickness, $kerf]);
    }
}

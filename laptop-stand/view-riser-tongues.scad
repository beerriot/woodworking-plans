//cmdline: --imgsize=800,1024
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

use <../common/labeling.scad>

$vpr=[ 96.50, 0.00, 359.80 ];
$vpt=[ 5.53, 2.00, 12.81 ];
$vpf=22.50;
$vpd=80.50;


rotate([0, -90 + tilt, 0])
translate([0, 0, -riser_width]) {
    riser(cut_fancy_end=false);

    translate([0, riser_width, riser_width + wood_thickness])
    rotate([90, 0, 0])
    riser(cut_fancy_end=false);

    translate([riser_length() - arm_width, 0, -wood_thickness])
        rotate([0, 90, 0])
        arm();

    translate([riser_length() - arm_width, 0, -wood_thickness * 0.95])
        guide(riser_width + wood_thickness * 0.95);

    translate([riser_length(), 0, -wood_thickness * 0.95])
        guide(wood_thickness * 0.9);
}

translate([riser_width + (riser_length() - arm_width) * sin(tilt),
           0,
           riser_length() - arm_width - foot_width * 1.5])
rotate([90, 0, 0])
color([0.5, 0.5, 0.5, 0.25])
text("b", size=foot_width * 2/3);


translate([(riser_width + wood_thickness) / cos(tilt), 0, 0])
foot(cut_fancy_ends=false);

translate([riser_width / cos(tilt) + wood_thickness * 0.05, 0, 0])
rotate([0, 90, 0])
guide(wood_thickness * 0.9);

translate([foot_width * tan(tilt), 0, foot_width])
rotate([0, 90, 0])
guide(riser_width / cos(tilt) + wood_thickness * 0.9);

translate([riser_width + wood_thickness, 0, foot_width + wood_thickness / 4])
rotate([90, 0, 0])
color([0.5, 0.5, 0.5, 0.25])
text("a", size=foot_width * 2/3);

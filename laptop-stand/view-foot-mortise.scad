//cmdline: --imgsize=1024,640
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

$vpr=[ 69.40, 0.00, 25.70 ];
$vpt=[ 11.89, 9.09, 0.41 ];
$vpf=22.50;
$vpd=54.08;

foot(cut_groove_end=false, cut_groove=false, cut_fancy_ends=false);
translate([foot_length() - foot_stretcher_inset_front() - stretcher_tenon_width(),
           0,
           foot_stretcher_inset_bottom()]) {
    translate([-stretcher_tenon_shoulder_depth(),
               wood_thickness * 5,
               -stretcher_tenon_face_depth()])
        rotate([90, 0, 90])
        stretcher();

    color([0.5, 0.5, 0.5, 0.25])
    translate([0, -wood_thickness, 0]) {
        rotate([-90, 0, 0])
        cylinder(wood_thickness * 6, 0.1, 0.1);
        translate([0, 0, stretcher_tenon_thickness()])
            rotate([-90, 0, 0])
            cylinder(wood_thickness * 6, 0.1, 0.1);
        translate([stretcher_tenon_width(), 0, stretcher_tenon_thickness()])
            rotate([-90, 0, 0])
            cylinder(wood_thickness * 6, 0.1, 0.1);
        translate([stretcher_tenon_width(), 0, 0])
            rotate([-90, 0, 0])
            cylinder(wood_thickness * 6, 0.1, 0.1);
    }
}

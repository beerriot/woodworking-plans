//cmdline: --imgsize=1024,640
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

$vpr=[ 66.40, 0.00, 25.70 ];
$vpt=[ 11.89, 9.09, 0.41 ];
$vpf=22.50;
$vpd=54.08;

riser(cut_end=false, cut_tongues=false, cut_fancy_end=false);
translate([riser_length() - riser_stretcher_inset_top() - stretcher_tenon_width(),
           0,
           riser_stretcher_inset_front()]) {
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

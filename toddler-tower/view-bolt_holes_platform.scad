//cmdline: --projection=o --imgsize=1152,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>
use <panel-build.scad>

include <params.scad>

use <view-windows_flats.scad>

$vpt = [ 30.67, 51.00, 26.43 ];
$vpr = [ 90.00, 0.00, 0.00 ];
$vpd = 166.58;

module view_bolt_holes_platform() {
    difference() {
        view_windows_flats();

        all_platform_bolt_holes();
    }
}

thirdAngle([bottom_depth, thickness /* TODO + bolt length */, height],
           frontLabels=[0,1,0],
           rightLabels=[0,0,0],
           topLabels=undef) {
    translate([0, thickness, 0])
        rotate([90, -90, 0])
        mirror([0, 1, 0])
        view_bolt_holes_platform(); /* TODO bolt */

    translate([bottom_depth, 0, platform_heights[0] - thickness / 2]) {
        translate([-bolt_hole_platform_front(), 0, 0])
            sizeLabel(bolt_hole_platform_front());
        translate([-bolt_hole_platform_rear(), 0, 0])
            sizeLabel(bolt_hole_platform_rear(), over=true);
    }

    taRightSide(thickness) {
        /* TODO bolt */
    }
}

// hide bottom of the side panel
color([1, 1, 1, 0.2])
translate([-bottom_depth, -1.01, -lower_window_height()])
cube([bottom_depth * 3, 1, lower_window_height() * 2]);

translate([bottom_depth - platform_depth,
           -(2 + bolt_hole_depth()),
           lower_window_height()
           - thirdAngleSize([platform_depth, thickness, inter_recess_span()],
                             frontLabels=[1,0,0],
                             rightLabels=undef,
                             topLabels=[1,0,1]).z]) {
    thirdAngle([platform_depth, thickness, inter_recess_span()],
               frontLabels=[1,0,0],
               rightLabels=undef,
               topLabels=[1,0,1]) {
        translate([platform_depth, thickness, 0])
            rotate([90, 0, 0])
            rotate([0, 0, 90])
            platform();

        union() {
            color([1, 1, 1, 0.5])
                translate([0,
                           -thickness / 2,
                           inter_recess_span() - bolt_hole_depth()])
                rotate([0, 0, -90])
                platform_bolt_holes();

            translate([platform_depth - bolt_hole_platform_front(),
                       0,
                       inter_recess_span() - bolt_hole_depth()])
                sizeLabel(bolt_hole_depth(), rotation=-90);
        }

        union() {
            /* no right side */
        }

        taTopSide(inter_recess_span()) {
            translate([platform_depth, 0, thickness / 2]) {
                translate([-bolt_hole_platform_front(), 0, 0])
                    sizeLabel(bolt_hole_platform_front());
                translate([-bolt_hole_platform_rear(), 0, 0])
                    sizeLabel(bolt_hole_platform_rear(), over=true);
            }
        }
    }
}

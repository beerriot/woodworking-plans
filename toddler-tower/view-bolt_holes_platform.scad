//cmdline: --projection=o --imgsize=1280,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>
use <panel-build.scad>

include <params.scad>

use <view-windows_flats.scad>

$vpt = [ 44.04, 51.00, 26.33 ];
$vpr = [ 90.00, 0.00, 0.00 ];
$vpd = 166.58;

module view_bolt_holes_platform() {
    difference() {
        view_windows_flats();

        all_platform_bolt_holes();
    }
}

thirdAngle([bottom_depth, thickness + bolt_length(), height],
           frontLabels=[0,1,0],
           rightLabels=[0,0,0],
           topLabels=undef) {
    union() {
        translate([0, thickness, 0])
            rotate([90, -90, 0])
            mirror([0, 1, 0])
            view_bolt_holes_platform();
        translate([bottom_depth - bolt_hole_platform_front(),
                   0,
                   platform_heights[1] - thickness / 2]) {
            translate([0, thickness, 0])
                rotate([90, 0, 0])
                bolt();
            translate([0, recess_depth(), 0])
                rotate([90, 0, 0])
                tt_threaded_insert();
        }
    }

    translate([bottom_depth, 0, platform_heights[0] - thickness / 2]) {
        translate([-bolt_hole_platform_front(), 0, 0])
            sizeLabel(bolt_hole_platform_front());
        translate([-bolt_hole_platform_rear(), 0, 0])
            sizeLabel(bolt_hole_platform_rear(), over=true);
    }

    taRightSide(thickness) {
        translate([-(bolt_hole_depth() - recess_depth()),
                   -bottom_depth,
                   platform_heights[1] - thickness / 2])
            sizeLabel(bolt_hole_depth());
    }
}

translate([thirdAngleSize([bottom_depth, thickness, height],
                          frontLabels=[0,1,0],
                          rightLabels=[0,1,0]).x,
           -(2 + bolt_hole_depth()),
           platform_heights[0]
           - thirdAngleSize([platform_depth, thickness, inter_recess_span()],
                             frontLabels=[0,0,0],
                             rightLabels=undef,
                             topLabels=[0,0,1]).z]) {
    thirdAngle([platform_depth, thickness, inter_recess_span()],
               frontLabels=[1,0,0],
               rightLabels=undef,
               topLabels=[1,0,0]) {
        translate([0, thickness, inter_recess_span()])
            rotate([90, 0, 0])
            rotate([0, 0, -90])
            platform();

        union() {
            color([1, 1, 1, 0.25])
                translate([0,
                           -thickness / 2,
                           inter_recess_span() - bolt_hole_depth()])
                rotate([0, 0, -90])
                platform_bolt_holes(bolt_hole_depth());

            translate([platform_depth - bolt_hole_platform_front(),
                       0,
                       inter_recess_span() - bolt_hole_depth()])
                sizeLabel(bolt_hole_depth(), rotation=-90, color="black");
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

//cmdline: --projection=o --imgsize=1280,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>
use <panel-build.scad>

include <params.scad>

use <view-bolt_holes_platform.scad>

$vpt = [ 2.62, 51.00, 12.10 ];
$vpr = [ 90.00, 0.00, 0.00 ];
$vpd = 98.54;

module view_bolt_holes_step() {
    difference() {
        view_bolt_holes_platform();

        all_front_step_bolt_holes();
    }
}

rotate([90, -90, 0])
mirror([0, 1, 0])
view_bolt_holes_step();

translate([0, -thickness, front_step_heights[0] - thickness / 2]) {
    sizeLabel(bolt_hole_step_front());
    sizeLabel(bolt_hole_step_rear(), over=true);
}

translate([-(front_step_depth() + sizeLabelHeight()),
           0,
           front_step_heights[len(front_step_heights)-1]
           - thirdAngleSize([front_step_depth(),
                             thickness,
                             inter_recess_span()],
                            frontLabels=[0,0,0],
                            rightLabels=undef,
                            topLabels=[0,0,1]).z]) {
    thirdAngle([front_step_depth(), thickness, inter_recess_span()],
               frontLabels=[1,0,0],
               rightLabels=undef,
               topLabels=[1,0,0]) {
        translate([front_step_depth(), thickness, 0])
            rotate([90, 0, 0])
            rotate([0, 0, 90])
            front_step();

        union() {
            color([1, 1, 1, 0.5])
                translate([0,
                           -thickness / 2,
                           inter_recess_span() - bolt_hole_depth()])
                rotate([0, 0, -90])
                front_step_bolt_holes();

            translate([front_step_depth() - bolt_hole_step_front(),
                       0,
                       inter_recess_span() - bolt_hole_depth()])
                sizeLabel(bolt_hole_depth(), rotation=-90);
        }

        union() {
            /* no right side */
        }

        taTopSide(inter_recess_span()) {
            translate([0, 0, thickness / 2]) {
                sizeLabel(bolt_hole_step_front());
                sizeLabel(bolt_hole_step_rear(), over=true);
            }
        }
    }
}

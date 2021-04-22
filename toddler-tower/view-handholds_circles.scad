//cmdline: --projection=o --imgsize=1152,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>
use <toddler-tower.scad>
use <panel-build.scad>

include <params.scad>

use <view-front_angle.scad>

$vpt = panel_vpt();
$vpr = panel_vpr();
$vpd = panel_vpd();

module view_handholds_circles() {
    difference() {
        view_front_angle();

        all_handholds(connect_circles=false);
    }
}

showBothSides() view_handholds_circles();

// climbing handholds
inset_for_lowest_handhold = inset_for_handhold(handhold_heights[0]);
for (i = [0 : len(handhold_heights) - 1]) {
    translate([0,
               max(sizeLabelHeight() * i + inset_for_lowest_handhold,
                   inset_for_handhold(handhold_heights[i])),
               thickness])
        viewLabel() sizeLabel(handhold_heights[i], rotation=-90, over=true);
 }
translate([handhold_heights[0], inset_for_lowest_handhold, thickness])
viewLabel() sizeLabel(handhold_size[1], rotation=-front_angle());

circle_center_distance = handhold_size[0] - handhold_size[1];

// standing handhold
translate([height - handhold_size[1], 0, thickness]) {
    translate([0, bottom_depth, 0]) {
        viewLabel() sizeLabel(top_handhold_offset());
        translate([0, -top_handhold_offset(), 0]) {
            viewLabel() sizeLabel(circle_center_distance);
            translate([0, -circle_center_distance, 0])
                viewLabel() sizeLabel(handhold_size[1], rotation=-90);
        }
    }
}

leftOrigin(thickness) {
    translate([handhold_heights[0], -inset_for_lowest_handhold, 0]) {
        viewLabel() sizeLabel(circle_center_distance,
                              rotation=90 + front_angle());
        translate([-cos(front_angle()) * circle_center_distance,
                   sin(front_angle()) * circle_center_distance
                   + handhold_size[1] / 2,
                   0])
            viewLabel() sizeLabel(handhold_size[1]);
    }
}

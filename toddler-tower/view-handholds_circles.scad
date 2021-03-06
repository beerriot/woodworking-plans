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

        climbing_handhold_positions()
            climbing_handhold_rotation()
            handhold_cutout_circles();

        upper_handhold_position()
            upper_handhold_rotation()
            handhold_cutout_circles();
    }
}

show_both_sides() view_handholds_circles();

// climbing handholds
inset_for_lowest_handhold = inset_for_handhold(handhold_heights[0]);
for (i = [0 : len(handhold_heights) - 1]) {
    translate([0,
               max(size_label_height() * i + inset_for_lowest_handhold,
                   inset_for_handhold(handhold_heights[i])),
               thickness])
        view_label() size_label(handhold_heights[i], rotation=-90, over=true);
 }
translate([handhold_heights[0], inset_for_lowest_handhold, thickness])
view_label() size_label(handhold_size[1], rotation=-front_angle());

circle_center_distance = handhold_size[0] - handhold_size[1];

// standing handhold
translate(upper_handhold_position() + [0, 0, thickness]) {
    view_label() size_label(top_handhold_offset(), rotation=180, over=true);
    view_label() size_label(circle_center_distance);
    translate([0, -circle_center_distance, 0])
        view_label() size_label(handhold_size[1], rotation=-90);
}

translate(left_origin()
          + [handhold_heights[0], -inset_for_lowest_handhold, thickness]) {
    view_label() size_label(circle_center_distance,
                          rotation=90 + front_angle());
    translate([-cos(front_angle()) * circle_center_distance,
               sin(front_angle()) * circle_center_distance
               + cutout_radius(),
               0])
        view_label() size_label(handhold_size[1]);
}

// Third-angle view.
//cmdline: --projection=o --imgsize=2048,2048
include <../common/echo-camera-arg.scad>

use <signal-tower.scad>
include <params.scad>

use <../common/labeling.scad>

$vpt = [ 234.08, 0.00, 384.95 ];
$vpr = [ 90.00, 0.00, 0.00 ];
$vpd = 2095.06;
$vpf = 22.50;

third_angle([wood_tower_base_radius() * 2,
             wood_tower_base_radius() * 2,
             assembled_height()]) {
    translate([wood_tower_base_radius(),
               wood_tower_base_radius(),
               0])
        tower();

    translate([wood_tower_base_radius() / 2, 0, 0])
    size_label(wood_tower_height(),
               rotation=-90,
               over=true,
               marker_radius=15,
               line_radius=1);

    ta_right_side(wood_tower_base_radius() * 2) {
        translate([wood_tower_base_radius() * 2, 0, 0])
        size_label(assembled_height(),
                   rotation=-90,
                   marker_radius=15,
                   line_radius=1);
    }

    ta_top_side(assembled_height()) {
        translate([wood_tower_base_radius(),
                   0,
                   wood_tower_base_radius() - leg_size.y])
            size_label(wood_tower_base_radius(),
                       marker_radius=15,
                       line_radius=1);
    }
}

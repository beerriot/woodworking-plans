// Third Angle view of Assembly
//cmdline: --projection=o --imgsize=1250,1250
include <../common/echo-camera-arg.scad>

include <params.scad>
use <laptop-stand.scad>
use <../common/labeling.scad>

// TODO set these
$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 29.38, -204.62, 29.5 ];
$vpf=22.50;
$vpd=162.58;

module assembly_key() {
    depth = riser_length() * sin(tilt) + arm_length() * cos(tilt);
    third_angle([depth, stand_width(), max_height()],
                front_labels=[2,1,1]) {
        assembly();

        // TODO side labels
        union() {
            translate([foot_width * tan(tilt), 0, 0])
                size_label(foot_length() - foot_width * tan(tilt));
            translate([foot_length(), 0, 0])
                rotate([0, -90, 0])
                size_label(max_height()
                           - (arm_length() - cleat_base_depth()) * sin(tilt));
            translate([riser_length() * sin(tilt),
                       0,
                       max_height()])
            rotate([0, tilt, 0])
                size_label(arm_length() - cleat_base_depth(), over=true);

            translate([foot_width * tan(tilt), 0, foot_width])
                angle_label(-15, 90, riser_length() / 2);
        }

        // TODO front labels
        ta_right_side(depth) {
            size_label(stand_width());
            rotate([0, -90, 0])
                size_label(max_height(), over=true);
        }

        // TODO top labels
        ta_top_side(max_height()) {
            translate([foot_width * tan(tilt), 0, 0])
                size_label(riser_length() * sin(tilt)
                           + arm_length() * cos(tilt)
                           - foot_width * tan(tilt));
        }
    }
}

assembly_key();

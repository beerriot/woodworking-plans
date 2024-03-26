// Key view of Laptop Stand components
//cmdline: --projection=o --imgsize=2200,1810

include <../common/echo-camera-arg.scad>

include <params.scad>
use <laptop-stand.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ -13.83, -400.00, 36.27 ];
$vpf=22.50;
$vpd=202.95;

parts_key();

module parts_key() {
    key([
         ["STRETCHER", 2, third_angle_size(stretcher_size(),
                                           top_labels=stretcher_top_labels)],
         ["FOOT", 2, third_angle_size(foot_size(),
                                      top_labels=foot_top_labels)],
         ["RISER", 2, third_angle_size(riser_size(),
                                       top_labels=riser_top_labels)],
         ["ARM", 2, third_angle_size(arm_size(),
                                     front_labels=arm_front_labels,
                                     top_labels=arm_top_labels)],
         ["CLEAT", 2, third_angle_size(cleat_size(),
                                       front_labels=cleat_front_labels)]
         ]) {
        stretcher_key();
        foot_key();
        riser_key();
        arm_key();
        cleat_key();
    }
}

function cleat_tongue_length() =
    cleat_base_depth() * (1 + tan(arm_taper()));

function cleat_size() =
    [wood_thickness + cleat_tongue_length(),
     wood_thickness,
     cleat_base_depth()];

cleat_front_labels=[1,1.5,1];

module cleat_key() {
    third_angle(cleat_size(),
                front_labels=cleat_front_labels) {
        rotate([0, 90, 0])
            translate([-cleat_base_depth(),
                       0,
                       -arm_width + cleat_tongue_length()])
            cleat();

        union() {
            size_label(cleat_tongue_length() + wood_thickness);
            translate([wood_thickness + cleat_tongue_length(),
                       0,
                       cleat_base_depth() - wood_thickness])
                size_label(wood_thickness, rotation=-90);
        }
        ta_right_side(cleat_size().x) {
            translate([0, 0, cleat_base_depth()])
                size_label(wood_thickness, over=true);
            translate([wood_thickness, 0, 0])
                size_label(cleat_base_depth(), rotation=-90);
        }
        ta_top_side(cleat_size().z) {
            size_label(cleat_tongue_length());
            translate([cleat_tongue_length(), 0, wood_thickness])
                size_label(wood_thickness, over=true);
        }
    }
}

function arm_size() =
    [arm_length(), wood_thickness, arm_width];

arm_front_labels=[0, 1, 1];
arm_top_labels=[1, 0, 0];

module arm_key() {
    third_angle(arm_size(),
                front_labels=arm_front_labels,
                top_labels=arm_top_labels) {
        arm();

        union() {
            size_label(arm_length());
            translate([arm_length(), 0, arm_width - cleat_base_depth()])
                rotate([0, -90, 0])
                size_label(cleat_base_depth());
        }
        ta_right_side(arm_size().x) {
            translate([0, 0, arm_width])
                size_label(wood_thickness, over=true);
            translate([wood_thickness, 0, 0])
                size_label(arm_width, rotation=-90);
        }
        ta_top_side(arm_size().z) {
            translate([0, 0, wood_thickness / 3]) {
                size_label(riser_width);

                translate([arm_length() - cleat_base_depth(), 0, 0])
                    size_label(cleat_base_depth());
            }
        }
    }
}

function riser_shift() =
    (foot_width * tan(tilt)) * 2 * sin(tilt);

function riser_size() =
    [riser_length()-riser_shift(), wood_thickness, riser_width];

riser_top_labels=[1,0,0];

module riser_key() {
    third_angle(riser_size(), top_labels=riser_top_labels) {
        translate([-riser_shift(), 0, 0])
            riser();

        union() {
            size_label(riser_length() - riser_shift());
            translate([riser_width * tan(tilt) - riser_shift(), 0, 0])
                rotate([0, -tilt, 0])
                size_label(foot_width, over=true);
            translate([foot_width / cos(tilt)
                       + riser_width * tan(tilt) - riser_shift(),
                       0,
                       0])
                angle_label(tilt, 90, riser_width);
        }
        ta_right_side(riser_size().x) {
            translate([0, 0, arm_width])
                size_label(wood_thickness, over=true);
            translate([wood_thickness, 0, 0])
                size_label(riser_width, rotation=-90);
        }
        ta_top_side(riser_size().z) {
            translate([riser_length() - riser_shift() - arm_width, 0, 0])
                size_label(arm_width);
        }
    }
}

function foot_size() =
    [foot_length() - foot_width * tan(tilt), wood_thickness, foot_width];

foot_top_labels=[1,0,0];

module foot_key() {
    third_angle(foot_size(), top_labels=foot_top_labels) {
        translate([-foot_width * tan(tilt), 0, 0])
            foot();

        union() {
            size_label(foot_length() - foot_width * tan(tilt));
            translate([riser_width, 0, foot_width])
                angle_label(tilt, -90-tilt, foot_width);
        }
        ta_right_side(stretcher_size().x) {
            size_label(wood_thickness);
            translate([wood_thickness, 0, 0])
                size_label(foot_width, rotation=-90);
        }
        ta_top_side(stretcher_size().z) {
            translate([0, 0, wood_thickness / 3])
                size_label(riser_width);
        }
    }
}

function stretcher_size() =
    [stand_width(), wood_thickness, stretcher_width];

stretcher_top_labels=[1,0,0];

module stretcher_key() {
    third_angle(stretcher_size(), top_labels=stretcher_top_labels) {
        stretcher();

        union() {
            size_label(stand_width());
        }
        ta_right_side(stretcher_size().x) {
            size_label(wood_thickness);
            translate([wood_thickness, 0, 0])
                size_label(stretcher_width, rotation=-90);
        }
        ta_top_side(stretcher_size().z) {
            translate([0, 0, wood_thickness])
                size_label(wood_thickness, over=true);
        }
    }
}

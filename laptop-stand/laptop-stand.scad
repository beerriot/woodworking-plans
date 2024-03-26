// Laptop Stand
use <../common/common.scad>

// INPUT PARAMETERS
include <params.scad>

// COMPUTED PARAMS

// height of the unit right under the screen
function max_height() =
    goal_height + laptop_screen_inset - laptop_case_depth;

// outside (max) length of the rear risers
function riser_length() =
    max_height() / cos(tilt);

function cleat_top_depth() =
    wood_thickness; // square on top

function cleat_base_depth() =
    cleat_top_depth()
    + cleat_height * sin(tilt); // tapers so front is plumb

// including riser cleat overlaps
function arm_length() =
    laptop_case_depth + cleat_base_depth();

function arm_taper() =
    atan2(arm_width - cleat_base_depth(),
          arm_length() - riser_width);

// from outside of left arm to outside of right arm
function stand_width() =
    laptop_case_width - 2 * arm_inset;

function stretcher_tenon_length() =
    wood_thickness; // stop at the outer edge

function stretcher_tenon_thickness() =
    wood_thickness * 2/3;

function stretcher_tenon_face_depth() =
    (wood_thickness - stretcher_tenon_thickness()) / 2;

function stretcher_tenon_width() =
    stretcher_width - (wood_thickness * 2/3);

function stretcher_tenon_shoulder_depth() =
    (stretcher_width - stretcher_tenon_width()) / 2;

function foot_length() =
    max_height() * sin(tilt) // area behind laptop
    + (laptop_case_depth * cos(tilt) // area under laptop
       * 0.9); // less a bit to give an external keyboard more room

function foot_stretcher_inset_front() =
    foot_length() / 3 - stretcher_tenon_width() / 2;

function foot_stretcher_inset_bottom() =
    (foot_width - stretcher_tenon_thickness()) / 2;

function riser_stretcher_inset_top() =
    riser_length() / 3 - stretcher_tenon_width() / 2;

function riser_stretcher_inset_front() =
    (riser_width  - stretcher_tenon_thickness()) / 2;

// COMPONENTS

module stock(length, width, errs=[0,0,0]) {
    square_stock([length, wood_thickness, width], errs);
}

module stretcher(cut_tenon=true) {
    difference() {
    color(stretcher_color)
        stock(stand_width(), stretcher_width);

        color(stretcher_tenon_color)
            if (cut_tenon) {
                stretcher_tenon_negative(-1);
                translate([stand_width() - stretcher_tenon_length(), 0, 0])
                    stretcher_tenon_negative(1);
            }
    }
}

module stretcher_tenon_negative(xerr) {
    // front
    stretcher_tenon_negative_face(xerr, -1);
    // back
    translate([0, wood_thickness - stretcher_tenon_face_depth(), 0])
        stretcher_tenon_negative_face(xerr, 1);

    // bottom
    stretcher_tenon_negative_shoulder(xerr, -1);
    // top
    translate([0, 0, stretcher_width - stretcher_tenon_shoulder_depth()])
        stretcher_tenon_negative_shoulder(xerr, 1);
}

module stretcher_tenon_negative_face(xerr, yerr) {
    square_stock([stretcher_tenon_length(),
                  stretcher_tenon_face_depth(),
                  stretcher_width],
                 [xerr, yerr, 2]);
}

module stretcher_tenon_negative_shoulder(xerr, zerr) {
    square_stock([stretcher_tenon_length(),
                  wood_thickness,
                  stretcher_tenon_shoulder_depth()],
                 [xerr, 2, zerr]);
}

// this is to cut the hole in the foot and riser, but it's here
// because its dimensions relate to the stretcher
module stretcher_mortise_negative() {
    square_stock([stretcher_tenon_width(),
                  wood_thickness,
                  stretcher_tenon_thickness()],
                 [0, 2, 0]);
}

module foot(cut_mortise=true, cut_groove_end=true, cut_groove=true, cut_fancy_ends=true) {
    color(foot_color)
        difference() {
        stock(foot_length(), foot_width);

        if (cut_mortise) {
            translate([foot_length() - (foot_stretcher_inset_front() + stretcher_tenon_width()), 0, foot_stretcher_inset_bottom()])
                stretcher_mortise_negative();
        }

        if (cut_groove_end) {
            // first cut the end off
            rotate([0, tilt, 0])
                translate([-foot_width, 0, 0])
                stock(foot_width, foot_width / cos(tilt),
                      [0, 2, 2]);
        }

        if (cut_groove) {
            // then cut the goove out
            rotate([0, tilt, 0])
                translate([0, wood_thickness / 3, 0])
                square_stock([riser_width, wood_thickness / 3, foot_width / cos(tilt) + riser_width * sin(tilt)],
                             [-1, 0, 2]);
        }

        if (cut_fancy_ends) {
            // riser end
            translate([foot_width * tan(tilt) * 2, 0, 0])
                rotate([0, -tilt, 0])
                translate([-foot_width, 0, 0])
                stock(foot_width, foot_width / cos(tilt),
                      [0, 2, 2]);

            // front end
            translate([foot_length(), 0, 0])
                rotate([0, -tilt, 0])
                stock(foot_width, foot_width / cos(tilt),
                      [0, 2, 2]);
        }
    }
}

module riser(cut_end=true,
             cut_mortise=true,
             cut_tongues=true,
             cut_fancy_end=true) {
    difference() {
        color(riser_color)
        stock(riser_length(), riser_width);

        if (cut_end) {
            translate([riser_width * tan(tilt), 0, 0])
            rotate([0, -tilt, 0])
                translate([-riser_width, 0, 0])
                stock(riser_width, riser_width / cos(tilt),
                      [0, 2, 2]);
        }

        if (cut_mortise) {
            translate([riser_length() - (riser_stretcher_inset_top() + stretcher_tenon_width()), 0, riser_stretcher_inset_front()])
                stretcher_mortise_negative();
        }

        color(riser_tongue_color)
            if (cut_tongues) {
                riser_tongue_negative_arm(-1);
                translate([0, wood_thickness * 2 / 3, 0])
                    riser_tongue_negative_arm(1);

                riser_tongue_negative_foot(-1);
                translate([0, wood_thickness * 2 / 3, 0])
                    riser_tongue_negative_foot(1);
            }

            if (cut_fancy_end) {
                fancy_tilt = tilt*2;
                translate([0,
                           wood_thickness / 3,
                           riser_width - ((foot_width / cos(tilt)) * tan(fancy_tilt))])
                    rotate([0, -fancy_tilt, 0])
                    color(riser_tongue_color)
                    square_stock([foot_width / cos(fancy_tilt) / cos(fancy_tilt),
                                  wood_thickness / 3,
                                  riser_width],
                                 [-1, 2, 0]);
            }
    }
}

module riser_tongue_negative_arm(yerr) {
    translate([riser_length() - arm_width, 0, 0])
        square_stock([arm_width, wood_thickness / 3, riser_width],
                     [1, yerr, 2]);
}

module riser_tongue_negative_foot(yerr) {
    translate([riser_width * tan(tilt) + foot_width / cos(tilt), 0, 0])
        rotate([0, -tilt, 0])
        translate([-foot_width, 0, 0])
        square_stock([foot_width,
                      wood_thickness / 3,
                      riser_width / cos(tilt) + foot_width * tan(tilt)],
                     [-1, 2, 2]);
}

module arm(cut_grooves=true, cut_taper=true) {
    color(arm_color)
        difference() {
        stock(arm_length(), arm_width);

        if (cut_grooves) {
            //riser groove
            translate([0, wood_thickness / 3, 0])
                square_stock([riser_width, wood_thickness / 3, arm_width],
                             [-1, 0, 2]);

            // cleat groove
            translate([arm_length() - cleat_base_depth(),
                       wood_thickness / 3,
                       0])
                square_stock([cleat_base_depth(),
                              wood_thickness / 3,
                              arm_width],
                             [1, 0, 2]);
        }

        if (cut_taper) {
            translate([riser_width, 0, 0])
                rotate([0, -arm_taper(), 0])
                translate([0, 0, -arm_width])
                stock(arm_length(), arm_width, [-1, 2, 0]);
        }
    }
}

module cleat(cut_tongue=true, cut_taper=true, cut_fancy_edge=true) {
    difference() {
        color(cleat_color)
            stock(cleat_base_depth(), arm_width + wood_thickness);

        color(cleat_tongue_color)
            if (cut_tongue) {
                cleat_tongue_negative(-1);
                translate([0, wood_thickness * 2 / 3, 0])
                    cleat_tongue_negative(1);
            }

        if (cut_taper) {
            translate([cleat_base_depth(), 0, arm_width - cleat_base_depth()])
            rotate([0, -arm_taper(), 0])
            translate([-cleat_base_depth() * 2,
                       wood_thickness / 3,
                       -arm_width])
            square_stock([cleat_base_depth() * 2,
                          wood_thickness / 3,
                          arm_width],
                         [0, 2, 0]);
        }

        if (cut_fancy_edge) {
            translate([cleat_base_depth(), 0, arm_width])
                rotate([0, -tilt, 0])
                stock(cleat_base_depth(), wood_thickness / cos(tilt),
                      [1, 2, 0]);
        }
    }
}

module cleat_tongue_negative(yerr) {
    square_stock([cleat_base_depth(), wood_thickness / 3, arm_width],
                 [2, yerr, -1]);
}

// ASSEMBLY

// The riser rotation has to happen at the point of the cutoff, which
// is not x=0. Abstracting the alteration here lets us reuse it for
// aligning the riser stretcher.
module riser_rotate() {
    translate([riser_width / cos(tilt), 0, 0])
        rotate([0, -(90-tilt), 0])
        translate([-riser_width * tan(tilt), 0, 0])
        children();
}

module side() {
    foot();

    riser_rotate() {
        riser();

        translate([riser_length() - arm_width, 0, riser_width])
            rotate([0, 90, 0]) {
            arm();

            translate([arm_length() - cleat_base_depth(), 0, 0])
                cleat();
        }
    }
}

module assembly() {
    side();
    translate([0, stand_width() - wood_thickness, 0])
        side();

    translate([foot_length()
               - (foot_stretcher_inset_front()
                  + stretcher_tenon_width()
                  + stretcher_tenon_shoulder_depth()),
               0,
               foot_stretcher_inset_bottom() - stretcher_tenon_face_depth()])
        rotate([90, 0, 90])
        stretcher();

    riser_rotate()
        translate([riser_length()
                   - (riser_stretcher_inset_top()
                      + stretcher_tenon_width()
                      + stretcher_tenon_shoulder_depth()),
                   0,
                   riser_stretcher_inset_front()
                   - stretcher_tenon_face_depth()])
        rotate([90, 0, 90])
        stretcher();
}

assembly();

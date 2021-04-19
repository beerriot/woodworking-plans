// Also known as a "learning tower", it's a step stool with a walled
// top step, to let kids stand at counter-top height without worrying
// about them falling off.

use <../common/common.scad>

$fs = 0.1;
$fa = 5;

include <params.scad>

// COMPUTED PARAMS
function front_angle() =
    atan((bottom_depth - platform_depth) / (height - front_step_heights[0]));

function front_step_depth() = bottom_depth / 4;

function front_step_inset(h) =
    max(0, (h - front_step_heights[0] - thickness)) * sin(front_angle());

function rabbet_depth() = thickness / 4;

function narrow_support_height() = front_step_heights[0];

function wide_support_height() =
    (height - platform_heights[len(platform_heights) - 1]) / 2;

function safety_rail_height() = thickness * 1.5;

// COMPONENTS

module sheet_stock(length, width, errs=[0,0,0]) {
    squareStock(length, width, thickness, errs);
}

module side_panel_blank() {
    sheet_stock(height, bottom_depth);
}

module front_angle_cut() {
    translate([front_step_heights[0], 0, 0])
        rotate([0, 0, front_angle()])
        translate([0, -bottom_depth, 0])
        sheet_stock(height, bottom_depth, errs=[2,0,2]);
}

module rabbet(length) {
    translate([0, 0, thickness])
        rotate([-90, 0, 0])
        sheet_stock(length, rabbet_depth(), [2, 2, 2]);
}

module front_step_rabbet() {
    rotate([0, 0, 90]) rabbet(front_step_depth());
}

module platform_rabbet() {
    rotate([0, 0, 90]) rabbet(platform_depth);
}

module narrow_support_rabbet() {
    rabbet(narrow_support_height());
}

module wide_support_rabbet() {
    rabbet(wide_support_height());
}

module safety_rail_rabbet() {
    rabbet(safety_rail_height());
}

module handhold_cutout_end() {
    cylinder(h=thickness + 0.02, r=handhold_size[1] / 2);
}

module handhold_cutout() {
    translate([0, 0, -0.01]) {
        hull() {
            handhold_cutout_end();
            translate([-(handhold_size[0] - handhold_size[1]), 0, 0])
                handhold_cutout_end();
        }
    }
}

module right_side() {
    difference() {
        side_panel_blank();

        front_angle_cut();

        for (h = front_step_heights)
            translate([h, front_step_inset(h), 0])
                front_step_rabbet();

        for (h = platform_heights)
            translate([h, bottom_depth - platform_depth, 0])
                platform_rabbet();

        // Non-step/platform cross-members

        // under the front steps
        translate([0, (front_step_depth() - thickness) / 2, 0])
            narrow_support_rabbet();

        // on the bottom against the cabinets
        translate([thickness, bottom_depth - thickness, 0])
            narrow_support_rabbet();

        translate([height - narrow_support_height(),
                   bottom_depth - thickness,
                   0]) {
            // at the top against the counter
            narrow_support_rabbet();

            // between the platforms and the top support, against the
            // cabinets
            translate([-wide_support_height() * 1.25, 0, 0])
                wide_support_rabbet();
        }

        translate([height - safety_rail_height(),
                   bottom_depth - platform_depth,
                   0])
            safety_rail_rabbet();

        for (h = handhold_heights)
            rotate([0, 0, front_angle()])
                translate([h, handhold_size[1] / 2, 0])
                handhold_cutout();

        translate([height - handhold_size[1],
                   bottom_depth - (platform_depth - handhold_size[0]) / 2,
                   0])
            rotate([0, 0, 90])
            handhold_cutout();
    }
}

module left_side() {
    mirror([0, 0, 1]) left_side();
}

right_side();

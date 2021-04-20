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

function inter_rabbet_span() = width - (thickness - rabbet_depth()) * 2;

function narrow_support_height() = front_step_heights[0] - thickness;

function wide_support_height() =
    (height - platform_heights[len(platform_heights) - 1]) / 2;

function safety_rail_height() = thickness * 1.5;

function cutout_radius() = handhold_size[1] / 2;

function upper_window_inset() = handhold_size[1] * 3;
function upper_window_height() =
    height - platform_heights[len(platform_heights) - 1]
    - upper_window_inset() * 2;
function upper_window_top_depth() =
    bottom_depth - upper_window_inset() * 2
    - (sin(front_angle())
       * (height - front_step_heights[0] - upper_window_inset()));
function upper_window_bottom_depth() =
    upper_window_top_depth() + sin(front_angle()) * upper_window_height();

function lower_window_inset() =
    front_step_depth() -sin(front_angle()) * front_step_heights[0];
function lower_window_height() =
    platform_heights[0] - thickness * 2 - cutout_radius();
function lower_window_upper_corner_offset() =
    sin(front_angle()) * lower_window_height() + cutout_radius();
function lower_window_top_depth() = front_step_depth();
function lower_window_bottom_depth() =
    bottom_depth + cutout_radius() - front_step_depth() - lower_window_inset();

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

module front_step() {
    sheet_stock(inter_rabbet_span(), front_step_depth());
}

module platform_rabbet() {
    rotate([0, 0, 90]) rabbet(platform_depth);
}

module platform() {
    sheet_stock(inter_rabbet_span(), platform_depth);
}

module bolt_hole() {
    translate([-thickness / 2, 0, -0.01])
        cylinder(h=thickness + 0.02, d=threaded_insert_od);
}

module front_step_bolt_holes() {
    translate([0, front_step_depth() * 0.2, 0])
        bolt_hole();
    translate([0, front_step_depth() * 0.8, 0])
        bolt_hole();
}

module platform_bolt_holes() {
    translate([0, platform_depth * 0.2, 0])
        bolt_hole();
    translate([0, platform_depth * 0.8, 0])
        bolt_hole();
}

module narrow_support_rabbet() {
    rabbet(narrow_support_height());
}

module narrow_support() {
    sheet_stock(inter_rabbet_span(), narrow_support_height());
}

module wide_support_rabbet() {
    rabbet(wide_support_height());
}

module wide_support() {
    sheet_stock(inter_rabbet_span(), wide_support_height());
}

module safety_rail_rabbet() {
    rabbet(safety_rail_height());
}

module safety_rail() {
    sheet_stock(inter_rabbet_span(), safety_rail_height());
}

module cutout_end() {
    translate([0, 0, -0.01])
        cylinder(h=thickness + 0.02, r=cutout_radius());
}

module handhold_cutout() {
    hull() {
        cutout_end();
        translate([-(handhold_size[0] - handhold_size[1]), 0, 0])
            cutout_end();
    }
}

module upper_window_cutout() {
    hull() {
        // upper counter-side corner is centered on origin
        cutout_end();

        // lower counter-side corner
        translate([-upper_window_height(), 0, 0])
            cutout_end();

        // upper non-counter-side corner
        translate([0, -upper_window_top_depth(), 0])
            cutout_end();

        // lower non-counter-side corner
        translate([-upper_window_height(), -upper_window_bottom_depth(), 0])
            cutout_end();
    }
}

module lower_window_cutout() {
    hull() {
        // lower non-counter-side edge is origin
        rotate([0, 0, front_angle()])
            translate([-0.5, 0, -0.01])
            cube([1, 1, thickness + 0.02]);

        // upper non-counter-side corner
        translate([lower_window_height(),
                   lower_window_upper_corner_offset(),
                   0])
            cutout_end();

        // upper counter-side corner
        translate([lower_window_height(),
                   lower_window_upper_corner_offset() + front_step_depth(),
                   0])
            cutout_end();

        // lower counter-side edge
        translate([0, lower_window_bottom_depth(), 0])
            rotate([0, 0, -atan((lower_window_bottom_depth()
                                 - lower_window_top_depth()
                                 - lower_window_upper_corner_offset())
                                / lower_window_height())])
            translate([-0.5, -1, -0.01])
            cube([1, 1, thickness + 0.02]);
    }
}

module right_side() {
    difference() {
        side_panel_blank();

        front_angle_cut();

        for (h = front_step_heights)
            translate([h, front_step_inset(h), 0]) {
                front_step_rabbet();
                front_step_bolt_holes();
            }

        for (h = platform_heights)
            translate([h, bottom_depth - platform_depth, 0]) {
                platform_rabbet();
                platform_bolt_holes();
            }

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

        // handholds for climbing
        for (h = handhold_heights)
            rotate([0, 0, front_angle()])
                translate([h, handhold_size[1] / 2, 0])
                handhold_cutout();

        // one more handhold at the top
        translate([height - handhold_size[1],
                   bottom_depth - (platform_depth - handhold_size[0]) / 2,
                   0])
            rotate([0, 0, 90])
            handhold_cutout();

        translate([height - upper_window_inset(),
                   bottom_depth - upper_window_inset(),
                   0])
            upper_window_cutout();

        translate([0, lower_window_inset(), 0])
            lower_window_cutout();
    }
}

module left_side() {
    mirror([0, 0, 1]) right_side();
}

// ASSEMBLY

module place_front_step_at(position) {
    translate([0,
               front_step_inset(front_step_heights[position]),
               front_step_heights[position] - thickness])
        children();
}

module place_platform_at(position) {
    translate([0,
               bottom_depth - platform_depth,
               platform_heights[position] - thickness])
        children();
}

module assembly() {
    rotate([0, -90, 0]) left_side();

    translate([width, 0, 0]) rotate([0, -90, 0]) right_side();

    translate([thickness - rabbet_depth(), 0, 0]) {
        // under step
        translate([0, (front_step_depth() + thickness) / 2, 0])
            rotate([90, 0, 0]) narrow_support();

        // bottom cabinet-side
        translate([0, bottom_depth, thickness])
            rotate([90, 0, 0]) narrow_support();

        translate([0, bottom_depth, height - narrow_support_height()]) {
            // top cabinet-side
            rotate([90, 0, 0]) narrow_support();

            // mid cabinet-side
            translate([0, 0, -wide_support_height() * 1.25])
                rotate([90, 0, 0]) wide_support();
        }

        translate([0,
                   bottom_depth - platform_depth + thickness,
                   height - safety_rail_height()])
            rotate([90, 0, 0]) safety_rail();

        place_front_step_at(0)
            front_step();

        place_platform_at(1)
            platform();
    }
}

assembly();

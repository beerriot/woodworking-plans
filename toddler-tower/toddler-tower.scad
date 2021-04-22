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

function recess_depth() = thickness / 4;

function inter_recess_span() = width - (thickness - recess_depth()) * 2;

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

function top_handhold_offset() =
    (platform_depth - handhold_size[0]) / 2;

function bolt_hole_step_front() = front_step_depth() * 0.2;
function bolt_hole_step_rear() = front_step_depth() * 0.8;

function bolt_hole_platform_front() = platform_depth * 0.2;
function bolt_hole_platform_rear() = platform_depth * 0.8;

// COMPONENTS

module sheet_stock(length, width, errs=[0,0,0]) {
    squareStock(length, width, thickness, errs);
}

module side_panel_blank() {
    color(side_color) sheet_stock(height, bottom_depth);
}

module front_angle_cut() {
    translate([front_step_heights[0], 0, 0])
        rotate([0, 0, front_angle()])
        translate([0, -bottom_depth, 0])
        color(side_color)
        sheet_stock(height, bottom_depth, errs=[2,0,2]);
}

module recess(length) {
    translate([0, 0, thickness])
        rotate([-90, 0, 0])
        sheet_stock(length, recess_depth(), [2, 2, 2]);
}

module dado(length) {
    color(dado_color) recess(length);
}

module rabbet(length) {
    color(rabbet_color) recess(length);
}

module groove(length) {
    color(groove_color) recess(length);
}

module front_step_dado() {
    deepest_inset = front_step_inset(front_step_heights[len(front_step_heights)-1]);
    translate([0, -deepest_inset, 0]) rotate([0, 0, 90]) dado(front_step_depth() + deepest_inset);
}

module front_step() {
    color(front_step_color)
        sheet_stock(inter_recess_span(), front_step_depth());
}

module platform_dado() {
    rotate([0, 0, 90]) dado(platform_depth);
}

module platform() {
    color(platform_color) sheet_stock(inter_recess_span(), platform_depth);
}

module bolt_hole() {
    translate([-thickness / 2, 0, -0.01])
        cylinder(h=thickness + 0.02, d=threaded_insert_od);
}

module front_step_bolt_holes() {
    translate([0, bolt_hole_step_front(), 0])
        bolt_hole();
    translate([0, bolt_hole_step_rear(), 0])
        bolt_hole();
}

module platform_bolt_holes() {
    translate([0, bolt_hole_platform_front(), 0])
        bolt_hole();
    translate([0, bolt_hole_platform_rear(), 0])
        bolt_hole();
}

module narrow_support_rabbet() {
    rabbet(narrow_support_height());
}

module narrow_support_groove() {
    groove(narrow_support_height());
}

module narrow_support() {
    color(narrow_support_color)
        sheet_stock(inter_recess_span(), narrow_support_height());
}

module wide_support_rabbet() {
    rabbet(wide_support_height());
}

module wide_support() {
    color(wide_support_color)
        sheet_stock(inter_recess_span(), wide_support_height());
}

module safety_rail_groove() {
    groove(safety_rail_height());
}

module safety_rail() {
    color(safety_rail_color)
        sheet_stock(inter_recess_span(), safety_rail_height());
}

module cutout_end() {
    translate([0, 0, -0.01])
        color(side_color)
        cylinder(h=thickness + 0.02, r=cutout_radius());
}

module handhold_cutout_circles() {
    cutout_end();
    translate([-(handhold_size[0] - handhold_size[1]), 0, 0])
        cutout_end();
}

module handhold_cutout(connect_circles=true) {
    if (connect_circles)
        hull() handhold_cutout_circles();
    else
        handhold_cutout_circles();
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

module at_platform_heights() {
    for (h = platform_heights)
        translate([h, 0, 0]) children();
}

module all_platform_dados() {
    at_platform_heights()
        translate([0, bottom_depth - platform_depth, 0])
        platform_dado();
}

module all_platform_bolt_holes() {
    at_platform_heights()
        translate([0, bottom_depth - platform_depth, 0])
        platform_bolt_holes();
}

module at_front_step_heights() {
    for (h = front_step_heights)
        translate([h, front_step_inset(h), 0]) children();
}

module all_front_step_dados() {
    at_front_step_heights() front_step_dado();
}

module all_front_step_bolt_holes() {
    at_front_step_heights() front_step_bolt_holes();
}

module all_rabbets_and_grooves() {

    // under the front steps
    translate([0, (front_step_depth() - thickness) / 2, 0])
        narrow_support_groove();

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
        safety_rail_groove();
}

function inset_for_handhold(h) =
    (h - front_step_heights[0]) * sin(front_angle())
    + handhold_size[1] / cos(front_angle());

module all_handholds(connect_circles=true) {

    // handholds for climbing
    for (h = handhold_heights)
        translate([h, inset_for_handhold(h), 0])
            rotate([0, 0, front_angle()])
            handhold_cutout(connect_circles);

    // one more handhold at the top
    translate([height - handhold_size[1],
               bottom_depth - top_handhold_offset(),
               0])
        rotate([0, 0, 90])
        handhold_cutout(connect_circles);
}

module right_side() {
    difference() {
        side_panel_blank();

        front_angle_cut();

        all_platform_dados();
        all_platform_bolt_holes();

        all_front_step_dados();
        all_front_step_bolt_holes();

        // Non-step/platform cross-members
        all_rabbets_and_grooves();

        all_handholds();

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

module assembly(front_step_position=0, platform_position=1) {
    rotate([0, -90, 0]) left_side();

    translate([width, 0, 0]) rotate([0, -90, 0]) right_side();

    translate([thickness - recess_depth(), 0, 0]) {
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

        place_front_step_at(front_step_position)
            front_step();

        place_platform_at(platform_position)
            platform();
    }
}

assembly();

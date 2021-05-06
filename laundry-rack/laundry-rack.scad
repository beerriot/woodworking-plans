// Folding Laundy Rack

use <../common/common.scad>

// TODO: animate open/close?

// finer faceting on small cylinders
$fs = 0.1;

// INPUT MEASUREMENTS
include <params.scad>

// COMPUTED MEASUREMENTS
function dowel_radius() = dowel_diameter / 2;
function short_dowel_length() =
    long_dowel_length - (square_stock_thickness * 2);

function dowel_inset() = square_stock_width / 2;
function double_square_stock_thickness() = square_stock_thickness * 2;

function height_to_leg_ratio() = sin(leg_angle);

// Complement is not used in the model, but is used in the diagrams
// and instructions.
function leg_angle_complement() = 90 - leg_angle;

function leg_length() =
    // hypotenuse of desired height plus half the width to hold the dowel
    (hanging_height / height_to_leg_ratio()) + (square_stock_width / 2);

// Positions of each dowel hole in the leg, relative to the floor end
function top_leg_dowel_distance() = leg_length() - square_stock_width / 2;
function middle_leg_dowel_distance() =
    (top_leg_dowel_distance() / (upper_ratio + lower_ratio)) * lower_ratio;
function bottom_leg_dowel_distance() =
    top_leg_dowel_distance() / (upper_ratio + lower_ratio);

// How far across the floor the middle pivot is, when the leg is standing
function leg_shift() = middle_leg_dowel_distance() * cos(leg_angle);

// distance from arm-to-arm pivot to leg-to-leg pivot
function pivot_vertical_span() =
    height_to_leg_ratio()
    * (top_leg_dowel_distance() - middle_leg_dowel_distance());

// Distance between the centers of the two pivot dowels in each arm
function arm_pivot_dowel_span() =
    (top_leg_dowel_distance() - middle_leg_dowel_distance()) * cos(leg_angle);

// Distance between centers of each dowel in the arms
function arm_hang_dowel_span() = arm_pivot_dowel_span() / (inner_dowels + 1);

// Total length of the arm component
function arm_length() =
    // distances between dowel centers, plus the overhang at each end
    arm_hang_dowel_span() * (inner_dowels + outer_dowels + 1)
    + square_stock_width;

// Position of each whole in each arm, relative to the end.
// They're symmetrical, so which end doesn't matter.
function arm_dowel_holes() =
    [for (i = [0 : (inner_dowels + outer_dowels + 1)])
            (square_stock_width / 2) + i * arm_hang_dowel_span()];

// Defining this may seem extraneous, but it makes the value available
// for HTML insertion.
function arm_dowel_hole_count() = len(arm_dowel_holes());

// How far across the floor the end of the left arm is from the base
// of the left leg. This is a negative number to make it easy to shift
// the arm assembly into position.
function end_of_left_arm() =
    leg_shift()
    - square_stock_thickness
    - (arm_hang_dowel_span() * (len(arm_dowel_holes()) - 1));

// 5: the four pivots, plus the foot of the wide legs
function long_dowel_count() = 5 + inner_dowels + outer_dowels;
function non_pivot_long_dowel_count() = long_dowel_count() - 4;

// Counted for just one arm.
function non_pivot_hanging_dowel_count() = inner_dowels + outer_dowels;

// 1: the foot of the narrow legs
function short_dowel_count() = 1 + inner_dowels + outer_dowels;

function paracord_radius() = paracord_diameter / 2;
function hook_wire_radius() = paracord_radius() / 2;
function hook_shaft_length() = dowel_diameter * 2;

// COLORS

module long_dowel_color() {
    color(long_dowel_color) children();
}
module short_dowel_color() {
    color(short_dowel_color) children();
}
module leg_color() {
    color(leg_color) children();
}
module arm_color() {
    color(arm_color) children();
}
module paracord_color() {
    color(paracord_color) children();
}
module hook_color() {
    color(hook_color) children();
}

// COMPONENTS

module dowel(length, errs=[0,0]) {
    rotate([0, 0, 90]) round_stock(length, dowel_radius(), errs);
}

module arm_leg_stock(length, errs=[0,0,0]) {
    translate([0, 0, -square_stock_width / 2])
        square_stock([length, square_stock_thickness, square_stock_width],
                     errs);
}

module long_dowel() {
    long_dowel_color() dowel(long_dowel_length);
}
module short_dowel() {
    short_dowel_color() dowel(short_dowel_length());
}

// subtract this from arm & leg
module dowel_hole(distance) {
    translate([distance, 0]) dowel(square_stock_thickness, [2, 0]);
}

module leg_blank() {
    leg_color() arm_leg_stock(leg_length());
}

module leg() {
    difference() {
        leg_blank();
        dowel_hole(bottom_leg_dowel_distance());
        dowel_hole(middle_leg_dowel_distance());
        dowel_hole(top_leg_dowel_distance());

        rotate([0, leg_angle, 0])
            translate([0, 0, -square_stock_width / 2])
            arm_leg_stock(square_stock_width, [-1, 2, 0]);
    }
}

module arm_blank() {
    arm_color() arm_leg_stock(arm_length());
}

module arm() {
    arm_color() difference() {
        arm_blank();
        for (i = arm_dowel_holes()) dowel_hole(i);
    }
}

module paracord_line(length) {
    paracord_color() cylinder(length, r=paracord_radius());
}

module paracord_loop() {
    paracord_color()
        rotate([90, 0, 0])
        rotate_extrude(convexity=10)
        translate([dowel_radius() + paracord_radius(), 0])
        circle(paracord_radius());
}

module hook() {
    hook_level = -(paracord_radius() * 1.5 + dowel_diameter * 2);
    hook_color() {
        // top loop
        rotate([90, 0, 0])
            rotate_extrude(convexity=10)
            translate([paracord_radius() + hook_wire_radius(), 0])
            circle(hook_wire_radius());
        // straight shaft
        translate([0, 0, hook_level])
            cylinder(hook_shaft_length(), r=hook_wire_radius());
        // curve
        translate([-(dowel_radius() + hook_wire_radius()), 0, hook_level])
            rotate([90, 0, 0])
            rotate_extrude(angle=-180, convexity=10)
            translate([dowel_radius() + hook_wire_radius(), 0])
            circle(hook_wire_radius());
        // end
        translate([-(dowel_diameter + hook_wire_radius() * 2), 0, hook_level])
            cylinder(dowel_diameter * 0.5, r=hook_wire_radius());
    }
}

module lock() {
    // hooks are asymetric, so cord has to run to the side of the dowel
    paracord_angle =
        atan((dowel_radius() + hook_wire_radius())/pivot_vertical_span());

    // length of the unit, given the swing out of the way
    hyp_length = pivot_vertical_span() / cos(paracord_angle);

    rotate([0, -paracord_angle, 0]) {
        paracord_loop();

        loop_half_height = dowel_radius() + paracord_radius();
        hook_half_height = hook_wire_radius() * 1.5 + hook_shaft_length();
        line_length = hyp_length - loop_half_height - hook_half_height;
        translate([0, 0, -(loop_half_height + line_length)])
            paracord_line(line_length);

        translate([0, 0, -(loop_half_height + line_length)]) hook();
    }
}

// ASSEMBLY
module narrow_arms() {
    translate([0, square_stock_thickness]) arm();
    translate([0, long_dowel_length - square_stock_thickness * 2]) arm();
    translate([arm_dowel_holes()[0], 0]) long_dowel();
    for (i = [0 : inner_dowels - 1])
        translate([arm_dowel_holes()[1 + i], square_stock_thickness])
            short_dowel();
    translate([arm_dowel_holes()[1 + inner_dowels], 0]) long_dowel();
    for (i = [0 : outer_dowels - 1])
        translate([arm_dowel_holes()[2 + inner_dowels + i],
                   square_stock_thickness])
            short_dowel();
}

module wide_arms(include_top=true, include_pivot=true) {
    if (include_top) arm();
    translate([0, long_dowel_length - square_stock_thickness]) arm();
    for (i = [0 : len(arm_dowel_holes()) - 2])
        if (i != outer_dowels || include_pivot)
            translate([arm_dowel_holes()[i], 0])
                long_dowel();
}

module legs(include_inner_top=true, include_outer_top=true) {
    rotate([0, -leg_angle, 0]) {
        if (include_outer_top) leg();
        translate([bottom_leg_dowel_distance(), 0]) long_dowel();
        translate([middle_leg_dowel_distance(), 0]) long_dowel();
        translate([0, long_dowel_length - square_stock_thickness]) leg();
    }

    translate([leg_shift() * 2, 0]) rotate([0, leg_angle, 0]) {
        if (include_inner_top)
            translate([0, square_stock_thickness])
                mirror([1, 0, 0])
                leg();
        translate([0, short_dowel_length()]) mirror([1, 0, 0]) leg();
        translate([-bottom_leg_dowel_distance(), square_stock_thickness])
            short_dowel();
    }
}

module assembly() {
    legs();

    translate([end_of_left_arm(), 0, hanging_height]) {
        wide_arms();

        translate([arm_dowel_holes()[len(arm_dowel_holes())-1], 0]) {
            translate([0, square_stock_thickness * 2 + paracord_radius()])
                lock();
            translate([0,
                       long_dowel_length - square_stock_thickness * 2 -
                       paracord_radius()])
                lock();
        }
    }
    translate([leg_shift() - dowel_inset(), 0, hanging_height])
        narrow_arms();
}

assembly();

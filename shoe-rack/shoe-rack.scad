// Shoe Rack
use <../common/common.scad>

// INPUT PARAMETERS
include <params.scad>

// COMPUTED PARAMS
function slat_length() = length - end_stock_thickness * 2;

function min_shelf_angle() =
    min([ for (ha = shelf_heights_and_angles) ha[1] ]);
function max_shelf_angle() =
    max([ for (ha = shelf_heights_and_angles) ha[1] ]);

function shelf_depth(shelf_angle) =
    end_depth / cos(reduce_unique_parts ? min_shelf_angle() : shelf_angle);

function shelf_cut_angle(shelf_angle) =
    reduce_unique_parts ? max_shelf_angle() : shelf_angle;

function slat_count(shelf_angle) =
    min(max_slats,
        floor(shelf_depth(shelf_angle)
              / (slat_stock_width + min_slat_spacing)));

function slat_space(shelf_angle) =
    let (slats = slat_count(shelf_angle))
    (shelf_depth(shelf_angle) - slat_stock_width * slats) / (slats - 1);

function slat_positions(shelf_angle) =
    let (depth = shelf_depth(shelf_angle), space = slat_space(shelf_angle))
    [0 : (slat_stock_width + space) : depth];

function lap_joint_depth() = end_stock_thickness / 2;

// Values used in the instructions
function total_end_stock_length_estimate() =
    (end_depth + end_height) * 4
    + shelf_depth(max_shelf_angle()) * len(shelf_heights_and_angles);

function sum_slats(i=0, n=0) =
    (i >= len(shelf_heights_and_angles))
    ? n
    : sum_slats(i + 1, n + slat_count(shelf_heights_and_angles[i][1]));
function total_slats() = sum_slats();

function shallowest_shelf_depth() = shelf_depth(min_shelf_angle());
function deepest_shelf_depth() = shelf_depth(max_shelf_angle());

function rest(list, fromi) =
    (fromi > len(list)-1)
    ? []
    : [ for (j=[(fromi+1):(len(list)-1)]) list[j] ];
function add_shelf_angle(angle, angles, i=0) =
    (i == len(angles)
     ? [[angle, 1]]
     : (angle == angles[i][0]
        ? concat([[angle, angles[i][1]+1]], rest(angles, i+1))
        : concat([angles[0]], add_shelf_angle(angle, angles, i+1))));
function count_unique_shelf_angles(i=0, angles=[]) =
    (i == len(shelf_heights_and_angles))
    ? angles
    : count_unique_shelf_angles(i+1,
                                add_shelf_angle(shelf_heights_and_angles[i][1],
                                                angles));
function unique_shelf_angles() =
    reduce_unique_parts
    ? [[max_shelf_angle(), len(shelf_heights_and_angles)]]
    : count_unique_shelf_angles();

function bottom_shelf_mounting_angle() = shelf_heights_and_angles[0][1];

// COLORS
module end_top_bottom_color() {
    color(end_top_bottom_color) children();
}
module end_front_back_color() {
    color(end_front_back_color) children();
}
module slat_color() {
    color(slat_color) children();
}
module shelf_support_color() {
    color(shelf_support_color) children();
}

// COMPONENTS

// default errs must be specified, or the call to square_stock will
// pass `undefined`, overriding the default there
module end_stock(length, errs=[0,0,0]) {
    square_stock([length, end_stock_thickness, end_stock_width], errs);
}

module slat_stock(length, errs=[0,0,0]) {
    square_stock([length, slat_stock_thickness, slat_stock_width], errs);
}

// `render()` is necessary to prevent z-index conflicts
// on the ends of the half-laps when put together
module end_piece(length) {
    render() difference() {
        end_stock(length);

        // halflap either end
        translate([0, -lap_joint_depth()]) {
            end_stock(end_stock_width, [-1, 0, 2]);
            translate([length - end_stock_width, 0])
                end_stock(end_stock_width, [1, 0, 2]);
        }
    }
}

module end_top_bottom() {
    end_top_bottom_color() end_piece(end_depth);
}

module end_front_back() {
    end_front_back_color() end_piece(end_height);
}

module shelf_support(shelf_angle, bottom=false) {
    cut_angle = shelf_cut_angle(shelf_angle);
    depth = shelf_depth(shelf_angle);

    shelf_support_color()
        render()
        translate([0, 0, end_stock_width])
        difference() {
        translate([0, 0, -end_stock_width])
            end_stock(depth);

        //cut off corner sticking out the front
        rotate([0, 90 - cut_angle, 0])
            translate([0, 0, -end_stock_width])
            end_stock(end_stock_width / cos(cut_angle), [1, 2, 1]);

        //cut off corner sticking out the back
        translate([depth, 0])
            rotate([0, 90 + cut_angle, 0])
            end_stock(end_stock_width / cos(cut_angle), [1, 2, 1]);

        // slots for slats
        for (x = slat_positions(shelf_angle))
            if (x != 0 || (x == 0 && shelf_angle < raised_front_slat_min_angle))
                translate([x, end_stock_thickness, slat_stock_thickness / 2])
                    rotate([-90, 0, -90])
                    slat_stock(end_stock_thickness, [2, 0, 0]);

        // remove the portion that hangs below the ends
        if (bottom)
            rotate([0, shelf_angle, 0])
                translate([0,
                           0,
                           -(end_stock_width - shelf_heights_and_angles[0][0])])
                end_stock(end_depth, [2, 2, -1]);
    }
}

module shelf_center(shelf_angle, bottom=false) {
    cut_angle = shelf_cut_angle(shelf_angle);
    depth = shelf_depth(shelf_angle);

    slat_color()
        rotate([-90, 0, 0])
        difference() {
        slat_stock(depth);

        //cut off corner sticking out the front
        rotate([0, 0, 90 - cut_angle])
            slat_stock(slat_stock_width / cos(cut_angle), [1, -1, 2]);

        //cut off corner sticking out the back
        translate([depth + slat_stock_thickness, 0])
            rotate([0, 0, 90 + cut_angle])
            slat_stock(slat_stock_width / cos(cut_angle), [1, 1, 2]);

        // slots for slats
        for (x = slat_positions(shelf_angle))
            if (x != 0 || (x == 0 && shelf_angle < raised_front_slat_min_angle))
                translate([x + slat_stock_width, -slat_stock_thickness / 2])
                    rotate([0, -90, 0])
                    slat_stock(slat_stock_width, [2, 0, 2]);

        // remove the portion that hangs below the ends
        if (bottom)
            rotate([0, 0, shelf_angle])
                slat_stock(end_depth, [2, -1, 2]);
    }
}

module slat() {
    slat_color()
    translate([0, 0, slat_stock_thickness])
    rotate([-90, 0, 0])
    slat_stock(slat_length());
}

// ASSEMBLY
module end() {
    translate([end_stock_thickness, 0])
        rotate([0, 0, 90]) {
        end_top_bottom();
        translate([0, 0, end_height - end_stock_width]) end_top_bottom();
        translate([0, end_stock_thickness])
            rotate([180, -90, 0])
            end_front_back();
        translate([end_depth - end_stock_width, end_stock_thickness])
            rotate([180, -90, 0])
            end_front_back();
    }
}

module shelf(shelf_angle,
             bottom=false,
             include_second_support=true,
             include_center_support=true,
             include_front_slat=true) {
    rotate([shelf_angle, 0, 0])
        translate([0, 0, -end_stock_width]) {
        translate([end_stock_thickness, 0])
            rotate([0, 0, 90])
            shelf_support(shelf_angle, bottom);

        if (include_second_support)
            translate([(length - end_stock_thickness * 2), 0])
                rotate([0, 0, 90])
                shelf_support(shelf_angle, bottom);

        if (include_center_support)
            translate([(slat_length() + slat_stock_width) / 2,
                       0,
                       end_stock_width])
                rotate([0, 0, 90])
                shelf_center(shelf_angle, bottom);

        for (y = slat_positions(shelf_angle),
                 // do not sink the front slat if the shelf angle is
                 // low; keep it raised to provide a leg for
                 // heels/toes to rest against
                 sink = (y == 0 && shelf_angle >= raised_front_slat_min_angle
                         ? 0
                         : slat_stock_thickness /2))
            translate([0, y, end_stock_width - sink])
                if (y != 0 || include_front_slat) slat();
    }
}

module assembly(include_second_end=true) {
    end();
    if (include_second_end) translate([length, 0]) mirror([1, 0,0]) end();

    for (i = [0:len(shelf_heights_and_angles)-1],
             h = shelf_heights_and_angles[i][0],
             a = shelf_heights_and_angles[i][1]) {
        translate([end_stock_thickness, 0, h]) shelf(a, i == 0);
    }
}

assembly();

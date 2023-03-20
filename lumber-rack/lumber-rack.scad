// Lumber Rack
use <../common/common.scad>

// INPUT PARAMETERS
include <params.scad>

// COMPUTED PARAMS

// full length of the shelf piece
function shelf_depth(height, thickness) =
    depth - (height - thickness) * tan(frame_angle);

function dado_depth() =
    floor(stock_breadth / 0.3) / 10;

function cross_brace_length(thickness) =
    thickness + (pair_separation - stock_breadth) * sqrt(2);

function leg_length(thickness) =
    height + 2*thickness * tan(frame_angle);

// USED IN WEB PAGE

function anti_dado_depth() =
    stock_breadth - dado_depth();

function shelf_count() =
    len(shelf_height);

// COMPONENTS

module stock(length, width, errs=[0,0,0]) {
    square_stock([length, stock_breadth, width], errs);
}

module support(height, thickness) {
    difference() {
        stock(depth, thickness);
        translate([depth - shelf_depth(height, thickness), 0, 0])
            rotate([0, -90+frame_angle, 0])
            translate([-depth/2, 0, 0])
            stock(depth, depth, [2, 2, 2]);
    }
}

module shelf(height, thickness) {
    color(shelf_color)
        difference() {
        support(height, thickness);
        translate([depth - thickness * tan(shelf_relief_angle) / 2, 0, 0])
            rotate([0, shelf_relief_angle - 90, 0])
            translate([0, 0, -depth])
            stock(depth, depth, [2, 2, 2]);
    }
}

module foot() {
    color(foot_color) support(shelf_height[0], shelf_thickness[0]);
}

module leg(thickness, dados=true) {
    shift = -(stock_breadth - dado_depth());
    difference() {
        color(leg_color)
            translate([0, shift, -thickness])
            stock(leg_length(thickness), thickness);

        rotate([0,90-frame_angle,0]) {
            translate([0, shift, -thickness])
                stock(depth, thickness, [2, 2, 0]);

            translate([0, shift, height])
                stock(depth, thickness, [2, 2, 0]);

            if (dados) {
                for (i = [0:len(shelf_height)-1])
                    color(leg_dado_color)
                        translate([0, 0, shelf_height[i]-shelf_thickness[i]])
                        stock(depth, shelf_thickness[i], [2,2,2]);
            }
        }
    }
}

module cross_stile(thickness, length) {
    difference() {
        color(brace_color)
            stock(length, thickness);

        color(brace_dado_color) {
            rotate([0, -45, 0]) stock(length, thickness, [0,2,0]);
            translate([length - thickness, 0, 0])
                rotate([0, 45, 0])
                stock(thickness, length, [0,2,0]);

            translate([(length - thickness) / 2, -stock_breadth / 2, 0])
                stock(thickness, thickness, [0, 2, 2]);
        }
    }
}

// WARNING: this makes 45deg braces. If you change params, make sure
// they still line up in mountable locations.
module cross_brace(thickness) {
    length = cross_brace_length(thickness);
    rotate([0, -45, 0]) cross_stile(thickness, length);
    translate([pair_separation - stock_breadth, stock_breadth, 0])
        rotate([0, -45, 180])
        cross_stile(thickness, length);
}

// ASSEMBLY

module left_side() {
    rotate([0,-(90-frame_angle),0])
        leg(rear_leg_thickness);
    translate([front_leg_thickness + 2*height * tan(frame_angle), stock_breadth, 0])
        rotate([0,-(90-frame_angle),180])
        leg(front_leg_thickness);

    foot();

    for (i = [1:len(shelf_height)-1]) {
        translate([0, 0, shelf_height[i]-shelf_thickness[i]])
            shelf(shelf_height[i], shelf_thickness[i]);
    }
}

module right_side() {
    translate([0, pair_separation + stock_breadth, 0])
        mirror([0,1,0]) left_side();
}

module lower_brace() {
    translate([0, pair_separation, shelf_height[0]/2])
        rotate([0, 90, 0]) rotate([0, 0, -90])
        cross_brace(lower_brace_thickness);
}

module upper_brace() {
    translate([depth - shelf_depth(shelf_height[2], shelf_thickness[2]) + stock_breadth, pair_separation, shelf_height[2]-shelf_thickness[2]])
        rotate([0, frame_angle, 0]) rotate([0, 0, -90])
        cross_brace(upper_brace_thickness);
}

module assembly() {
    left_side();
    right_side();
    lower_brace();
    upper_brace();
}

assembly();

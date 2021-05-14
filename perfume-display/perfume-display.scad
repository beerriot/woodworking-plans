// A tray with an array of specifically sized holes for carrying a
// selection of perfume vials.
use <../common/common.scad>

$fs = 0.1;
$fa = 5;

// INPUT PARAMS
include <params.scad>

// COMPUTED PARAMS
function max_vial_diameter() = max([ for (i = vials) i[0] ]);
function min_vial_diameter() = min([ for (i = vials) i[0] ]);

function min_center_distance_required() =
    min_inter_vial_distance + max_vial_diameter();

function default_center_distance_required() =
    default_inter_vial_distance + min_vial_diameter();

function vial_center_distance() =
    max(min_center_distance_required(), default_center_distance_required());

function static_border() = [border.x, border.y, 0];

function usable_plank_space() = plank_size - static_border() * 2;

function row_offset(row) =
    [(row % 2) * vial_center_distance() / 2,
     row * sqrt(3) * vial_center_distance() / 2,
     0];

function real_max_vials() =
    [usable_plank_space().x / vial_center_distance(),
     usable_plank_space().y / (vial_center_distance() / 2 * sqrt(3))];

function int_max_vials() =
    [for (d = real_max_vials()) floor(d)];

function equal_size_rows() =
    (real_max_vials().x - int_max_vials().x) >= 0.5;

function dynamic_border() =
    [(usable_plank_space().x
      - (int_max_vials().x - 1) * vial_center_distance()
      - (equal_size_rows()
         ? 0.5 * vial_center_distance() // shift left for equal-size rows
         : 0)) / 2,                     // no shift for alternating-size rows
     (usable_plank_space().y - (int_max_vials().y - 1) * row_offset(1).y) / 2,
     0];

function vials_in_row(row) =
    int_max_vials().x - (equal_size_rows() ? 0 : (row % 2));

function relative_vial_positions(row) =
    [ for (i = [0 : vials_in_row(row) - 1])
            [i * vial_center_distance(), 0, 0] ];

function vial_positions() =
    [ for (i = [0 : int_max_vials().y - 1])
            for (j = relative_vial_positions(i))
                let (d = diameter_and_depth_of_vials_in_row(i))
                    [j + row_offset(i) + [0, 0, plank_size.z - d[1]], d[0]] ];

function diameter_and_depth_of_vials_in_row(i,
                                            count_row=0,
                                            vials_batch=0,
                                            vial_count=0) =
    (count_row == i)
    ? [vials[vials_batch][0], vials[vials_batch][1]]
    : (let (sum_vial_count = vial_count + vials_in_row(count_row),
            new_vial_count = (sum_vial_count > vials[vials_batch][2]
                              ? 0
                              : sum_vial_count),
            new_vials_batch = (sum_vial_count > vials[vials_batch][2]
                               ? (vials_batch + 1) % len(vials)
                               : vials_batch))
       diameter_and_depth_of_vials_in_row(i,
                                          count_row+1,
                                          new_vials_batch,
                                          new_vial_count));

// For instructions
function total_vial_count() = len(vial_positions());
function total_row_count() = int_max_vials().y;
function bottom_row_inset() = (static_border() + dynamic_border()).y;
function inter_row_space() = row_offset(1).y;
function wide_row_inset() =
    (static_border() + dynamic_border() + row_offset(0)).x;
function wide_row_vial_count() = vials_in_row(0);
function narrow_row_inset() =
    (static_border() + dynamic_border() + row_offset(1)).x;
function narrow_row_vial_count() = vials_in_row(1);

// COMPONENTS
module plank() {
    cube(plank_size);
}

module drill_hole(diameter) {
    cylinder(r=diameter / 2, h=plank_size.z + 0.1);
}

module bevel_cut() {
    thickness = (bevel[1] * sin(bevel[0])) + 0.01;
    height = (bevel[1] / cos(bevel[0])) + 0.02;
    translate([0, 0, bevel[1]])
        rotate([bevel[0], 0, 0])
        translate([-0.01, -thickness, 0.01 - height])
        cube([max(plank_size.x, plank_size.y) + 0.02,
              thickness,
              height]);
}

module groove_cut(plank_dimension) {
    radius = groove[0] / 2;
    length = plank_dimension * groove[1];
    translate([plank_dimension / 2, 0, plank_size.z / 2])
        rotate([0, 90, 0])
        union() {
        cylinder(h=length,
                 r=radius,
                 center=true);
        translate([0, 0, length / 2]) sphere(r=radius);
        translate([0, 0, -length / 2]) sphere(r=radius);
    }
}

// fill the holes with color so they're visible in orthographic projection
module fill_holes_for_orthographic() {
    bevel_shift = [0.01, 0.01, bevel[1]];
    color([0,0,0,0.8])
        translate(bevel_shift)
        cube(plank_size - bevel_shift * 2);
}

// ASSEMBLY

module bevels() {
    // bottom
    bevel_cut();

    // top
    translate([0, 0, plank_size.z]) mirror([0,0,1]) bevel_cut();
}

module back_side() {
    translate([0, plank_size.y, 0]) mirror([0,1,0]) children();
}

module left_side() {
    rotate([0, 0, 90]) mirror([0, 1, 0]) children();
}

module right_side() {
    translate([plank_size.x, 0, 0]) rotate([0, 0, 90]) children();
}

module assembly(chamfer=true, groove=true) {
    color(plank_color)
        difference() {
        plank();

        // vial holes
        translate(static_border() + dynamic_border())
            for (i = vial_positions())
                translate(i[0]) drill_hole(i[1]);

        if (chamfer) {
            bevels();
            back_side() bevels();
            left_side() bevels();
            right_side() bevels();
        }

        if (groove) {
            groove_cut(plank_size.x);
            back_side() groove_cut(plank_size.x);
            left_side() groove_cut(plank_size.y);
            right_side() groove_cut(plank_size.y);
        }
    }
}

assembly();

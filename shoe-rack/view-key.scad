// Just the key
//cmdline: --projection=o --imgsize=2048,1024
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 24.65, -400.00, 36.97 ];
$vpf=22.50;
$vpd=206.02;

module end_piece_key(length) {
     third_angle([length, end_stock_thickness, end_stock_width],
                 top_labels=[0,1,1]) {
         children();

         size_label(length);

         ta_right_side(length) {
             translate([end_stock_thickness, 0])
                 size_label(end_stock_width, rotation=-90);
             size_label(end_stock_thickness);
         }

         ta_top_side(end_stock_width) {
             translate([length, 0, 0])
                 size_label(end_stock_thickness / 2, rotation=-90);
             translate([length - end_stock_width, 0, 0])
                 size_label(end_stock_width);
         }
     }
}
function end_piece_key_size(length) =
    third_angle_size([length, end_stock_thickness, end_stock_width],
                     top_labels=[0,1,1]);

module shelf_support_or_center_key(shelf_angle, height, thickness) {
    cut_angle = shelf_cut_angle(shelf_angle);
    depth = shelf_depth(shelf_angle);

    cut_distance = height * tan(cut_angle);

    third_angle([depth, thickness, height],
                front_labels=[1,0,1],
                top_labels=(cut_angle == 0 ? undef : [1,0,0])) {
        children();

        union() {
            translate([cut_distance, 0])
                size_label(depth - cut_distance * 2);

            sp = [ for (x = slat_positions(shelf_angle)) x ];
            for (x = [1 : len(sp) - 1]) {
                translate([sp[x - 1], 0, height])
                    size_label(sp[x] - sp[x - 1], over=true);
            }

            translate([sp[len(sp) - 1], 0, height])
                size_label(slat_stock_width, over=true);
            if (cut_angle > 0)
                translate([0, 0, height])
                    angle_label(cut_angle, -90, height);
        }

        ta_right_side(depth) {
            size_label(thickness);
            translate([thickness, 0])
                size_label(height, rotation=-90);
        }

        // This generates a fourth child, even if cut_angle == 0, which
        // is why top_labels must be set to undef in the module
        // parameters.
        if (cut_angle != 0)
            translate([0, thickness, height])
                rotate([-90, 0, 0])
                size_label(depth, over=true);
    }
}

function shelf_support_or_center_key_size(shelf_angle, height, thickness) =
    third_angle_size([shelf_depth(shelf_angle), thickness, height],
                     front_labels=[1,0,1],
                     top_labels=[1,0,0]);

module shelf_support_key(shelf_angle) {
    shelf_support_or_center_key(shelf_angle,
                                end_stock_width,
                                end_stock_thickness)
        shelf_support(shelf_angle);
}

function shelf_support_key_size(shelf_angle) =
    shelf_support_or_center_key_size(shelf_angle,
                                     end_stock_width,
                                     end_stock_thickness);

module shelf_center_key(shelf_angle) {
    shelf_support_or_center_key(shelf_angle,
                                slat_stock_thickness,
                                slat_stock_width)
        translate([0, 0, slat_stock_thickness])
        shelf_center(shelf_angle);
}

function shelf_center_key_size(shelf_angle) =
    shelf_support_or_center_key_size(shelf_angle,
                                     slat_stock_thickness,
                                     slat_stock_width);

module slat_key() {
    third_angle([slat_length(), slat_stock_width, slat_stock_thickness]) {
        slat();

        size_label(slat_length());

        ta_right_side(slat_length()) {
            size_label(slat_stock_width);
            translate([slat_stock_width, 0])
                size_label(slat_stock_thickness, rotation=-90);
        }
    }
}
function slat_key_size() =
    third_angle_size([slat_length(), slat_stock_width, slat_stock_thickness],
                     top_labels=undef);

// KEY
module parts_key() {
    module labeled_shelf_piece(i, height, thickness) {
        function distance_to(i) =
            i == 0
            ? 0
            : (shelf_support_or_center_key_size(unique_shelf_angles()[i-1][0],
                                                height,
                                                thickness).x
               + end_stock_width * 1.5 + distance_to(i-1));

        ith_shift =
            shelf_support_or_center_key_size(unique_shelf_angles()[i][0],
                                             height,
                                             thickness).x + 1;
        translate([distance_to(i),  0, 0]) {
            children();
            translate([ith_shift, 0, height / 2 + size_label_height()])
                rotate([90, 0, 0])
                text(str("(", unique_shelf_angles()[i][1]*2, ")"),
                     size=end_stock_width / 2,
                     valign="center");
        }
    }

    key([["END FRONT/BACK", 4, end_piece_key_size(end_depth)],
         ["END TOP/BOTTOM", 4, end_piece_key_size(end_height)],
         ["SHELF SLAT", total_slats(), slat_key_size()],
         ["SHELF SUPPORT",
          len(shelf_heights_and_angles) * 2,
          shelf_support_key_size(0)],
         ["SHELF CENTER",
          len(shelf_heights_and_angles) * 2,
          shelf_center_key_size(0)]]) {
        end_piece_key(end_depth) end_top_bottom();
        end_piece_key(end_height) end_front_back();
        slat_key();
        for (i=[0 : len(unique_shelf_angles()) - 1])
            labeled_shelf_piece(i, end_stock_width, end_stock_thickness)
                shelf_support_key(unique_shelf_angles()[i][0]);
        for (i=[0 : len(unique_shelf_angles()) - 1])
            labeled_shelf_piece(i, slat_stock_thickness, slat_stock_width)
                translate([0, 0, slat_stock_thickness])
                shelf_center_key(unique_shelf_angles()[i][0]);
    }
}

parts_key();

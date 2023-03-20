// Key view of Assembly
//cmdline: --projection=o --imgsize=2560,1280
include <../common/echo-camera-arg.scad>

include <params.scad>
use <lumber-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 40.99, -400.00, 65.30 ];
$vpf=22.50;
$vpd=400.37;

parts_key();

module parts_key() {
    key([
         ["SHELF", "2 each", shelves_size()],
         ["FOOT", 2, third_angle_size(foot_size())],
         ["UPPER BRACE", 2,
          third_angle_size(brace_size(upper_brace_thickness),
                           top_labels=[1,1,0], spacing=2)],
         ["LOWER BRACE", 2,
          third_angle_size(brace_size(lower_brace_thickness),
                           top_labels=[1,1,0], spacing=2)],
         ["REAR LEGS", "1 each",
          third_angle_size(leg_size(rear_leg_thickness),
                           top_labels=[1,1,0], spacing=2)],
         ["FRONT LEGS", "1 each",
          third_angle_size(leg_size(front_leg_thickness),
                           top_labels=[1,1,0])],
         ]) {
        shelves_key();
        foot_key();
        brace_key(upper_brace_thickness);
        brace_key(lower_brace_thickness);
        leg_key(rear_leg_thickness);
        leg_key(front_leg_thickness);
    }
}

module shelves_key() {
    shelf_placements = shelf_placements();
    for (i=[1 : len(shelf_height)-1]) {
        translate(shelf_placements[i]) {
            translate([shelf_depth(shelf_height[i], shelf_thickness[i])
                       - depth, 0, 0])
                shelf(shelf_height[i], shelf_thickness[i]);
            size_label(shelf_depth(shelf_height[i], shelf_thickness[i]));
            if ((i == len(shelf_height)-1) ||
                (shelf_thickness[i+1] != shelf_thickness[i])) {
                translate([shelf_depth(shelf_height[i], shelf_thickness[i]),
                           0, 0])
                    size_label(shelf_thickness[i], rotation=-90);
            }
        }
    }

    angle_label(-5, 90, size=shelf_thickness[1]);
    translate([shelf_depth(shelf_height[1], shelf_thickness[1]), 0,
               shelf_thickness[1]/2])
        angle_label(-30, -90, size=shelf_thickness[1]/2);
}

function shelf_placements() =
    shelf_placements_helper(2, shelf_thickness[1], [[-1,-1,-1],[0,0,0]]);

function shelf_placements_helper(i, last_thickness, placements) =
    (i >= len(shelf_height))
    ? placements
    : shelf_placements_helper(i+1,
                              shelf_thickness[i],
                              concat(placements,
                                     [[(shelf_thickness[i] == last_thickness)
                                       ? (placements[i-1].x +
                                          shelf_depth(shelf_height[i-1],
                                                      shelf_thickness[i-1]) +
                                          size_label_height())
                                       : 0,
                                       0,
                                       (shelf_thickness[i] == last_thickness)
                                       ? placements[i-1].z
                                       : (placements[i-1].z +
                                          third_angle_size([0, 0, last_thickness]).z)]]));

function shelves_size() =
    [depth, stock_breadth,
     (shelf_placements()[len(shelf_thickness)-1]).z
     + shelf_thickness[len(shelf_thickness)-1]];

module foot_key() {
    third_angle(foot_size(), right_labels=undef) {
        foot();

        union() {
            size_label(depth);
            translate([depth, 0, 0])
                size_label(shelf_thickness[0], rotation=-90);
            angle_label(-5, 90, size=shelf_thickness[0]);
        }
        union() {};
        ta_top_side(shelf_thickness[0]) {
            translate([depth, 0, 0])
                size_label(stock_breadth, rotation=-90);
        }
    }
}

function foot_size() =
    [depth, stock_breadth, shelf_thickness[0]];

module brace_key(thickness) {
    third_angle(brace_size(thickness), right_labels=undef,
                top_labels=[1,1,0], front_labels=[0,1,1]) {
        cross_stile(thickness, cross_brace_length(thickness));

        union() {
            translate([(cross_brace_length(thickness)-thickness)/2, 0, 0])
                size_label(thickness);
            translate([cross_brace_length(thickness), 0, 0])
                size_label(thickness, rotation=-90);
            angle_label(45, 0, size=thickness);
        }
            ta_right_side(0) {}
        ta_top_side(thickness) {
            translate([0, 0, stock_breadth])
                size_label(cross_brace_length(thickness), over=true);
            translate([cross_brace_length(thickness),0,0])
                size_label(stock_breadth, rotation=-90);
        }
    }
}

function brace_size(thickness) =
    [cross_brace_length(thickness), stock_breadth, thickness];

module leg_key(thickness) {
    third_angle(leg_size(thickness), right_labels=undef, top_labels=[1,1,0]) {
        translate([0, dado_depth(), thickness]) {
            translate([0, 0, stock_breadth/2])
                rotate([180, 0, 0]) leg(thickness);
            mirror([0, 1, 0]) leg(thickness);
        }

        union() {
            translate([0, 0, thickness]) angle_label(5, -90, size=thickness);
            translate([0, 0, thickness+stock_breadth/2])
                angle_label(-5, 90, size=thickness);
            translate([sin(frame_angle) * thickness, 0, 0])
                for (i = [0 : len(shelf_height)-1]) {
                    translate([shelf_height[i] - shelf_thickness[i], 0])
                        size_label(shelf_thickness[i]);
                    if (i > 0) {
                        translate([shelf_height[i-1], 0, 0])
                            size_label(shelf_height[i] - shelf_thickness[i]
                                       - shelf_height[i-1]);
                    }
                }
            translate([leg_length(thickness), 0, 0])
                size_label(thickness, rotation=-90);
        }
        union() {}
        ta_top_side(thickness) {
            translate([leg_length(thickness), 0, 0])
                size_label(stock_breadth, rotation=-90);
            translate([0, 0, stock_breadth])
                size_label(leg_length(thickness), over=true);
        }
    }
}

module rear_leg_key() {
    translate([0, dado_depth(), rear_leg_thickness]) {
        rotate([180, 0, 0]) leg(rear_leg_thickness);
        mirror([0, 1, 0]) leg(rear_leg_thickness);
    }
}

module front_leg_key() {
    translate([0, dado_depth(), front_leg_thickness]) {
        rotate([180, 0, 0]) leg(front_leg_thickness);
        mirror([0, 1, 0]) leg(front_leg_thickness);
    }
}

function leg_size(thickness) =
    [leg_length(thickness), stock_breadth, thickness*2 + stock_breadth/2];

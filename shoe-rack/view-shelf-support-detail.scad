// Clear view of cuts for shelf supports.
//cmdline: --projection=o --imgsize=1200,600
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 22, 4.44, 8.45 ];
$vpf=22.50;
$vpd=145.77;

$fa=1;
$fs=0.1;

space_between_parts = end_stock_width * 2;
function combined_width_of(i) =
    (i < 0)
    ? 0
    : shelf_depth(unique_shelf_angles()[i][0]) + space_between_parts;

function center_of(i) =
    shelf_depth(unique_shelf_angles()[i][0]) / 2
    + combined_width_of(i - 1);

end_size = third_angle_size([shelf_depth(max_shelf_angle()),
                             end_stock_thickness,
                             end_stock_width],
                            front_labels=[1,0,1],
                            right_labels=undef,
                            top_labels=undef);
center_size = third_angle_size([shelf_depth(max_shelf_angle()),
                                slat_stock_width,
                                slat_stock_thickness],
                               front_labels=[0,0,1],
                               right_labels=undef,
                               top_labels=undef);

key([["SHELF CENTER", len(shelf_heights_and_angles), center_size],
     ["SHELF SUPPORT", len(shelf_heights_and_angles) * 2, end_size]]) {
    for (i = [0 : len(unique_shelf_angles()) - 1]) {
        shelf_angle = unique_shelf_angles()[i];
        translate([combined_width_of(i-1), 0, 0]) {
            third_angle(center_size) {
                union() {
                    translate([0, 0, slat_stock_thickness / 2])
                        shelf_center(shelf_angle[0]);
                    translate([shelf_depth(shelf_angle[0])
                               + end_stock_width / 4,
                               0])
                        rotate([90, 0, 0])
                        text(str("(",shelf_angle[1],")"),
                             halign="left",
                             size=end_stock_width * 0.65);
                }

                size_label(shelf_depth(shelf_angle[0]));
            }
        }
    }
    for (i = [0 : len(unique_shelf_angles()) - 1]) {
        shelf_angle = unique_shelf_angles()[i];
        translate([combined_width_of(i - 1), 0, 0]) {
            third_angle(end_size, right_labels=undef) {
                union() {
                    shelf_support(shelf_angle[0]);
                    translate([shelf_depth(shelf_angle[0])
                               + end_stock_width / 4,
                               0])
                        rotate([90, 0, 0])
                        text(str("(",shelf_angle[1] * 2,")"),
                             halign="left",
                             size=end_stock_width * 0.65);
                }

                union() {
                    size_label(shelf_depth(shelf_angle[0]));

                    if (shelf_angle[0] > 0)
                        translate([0, 0, end_stock_width])
                            angle_label(shelf_angle[0],
                                        -90,
                                        end_stock_width*1.25);

                    sp = [ for (x = slat_positions(shelf_angle[0])) x ];
                    translate([0, 0, end_stock_width]) {
                        for (x = [0 : ceil(len(sp) / 2)-1]) {
                            if (x > 0 ||
                                shelf_angle[0] < raised_front_slat_min_angle)
                                translate([sp[x], 0, 0])
                                    color("white")
                                    size_label(slat_stock_width);

                            if (x > 0)
                                translate([0, 0, size_label_height() * (x - 1)])
                                    size_label(sp[x], over=true);
                        }
                    }
                }
            }
        }
    }
}

for (i = [0 : len(unique_shelf_angles()) - 1]) {
    shelf_angle = unique_shelf_angles()[i];
    translate([combined_width_of(i-1) + shelf_depth(shelf_angle[0]) / 2,
               0,
               -size_label_height()])
        rotate([90, 0, 0])
        text(str(shelf_angle[0], "º"),
             halign="center",
             valign="top",
             size=end_stock_width);
 }

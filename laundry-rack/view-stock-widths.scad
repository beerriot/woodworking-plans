// End-on views of the stock to be used.
//cmdline: --projection=o --imgsize=800,400
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 7.38, -124.10, -0.69 ];
$vpf=22.50;
$vpd=53.88;

module leg_arm_example() {
    translate([square_stock_thickness, 0, square_stock_width / 2])
        rotate([0, 0, 90]) leg_color() arm_leg_stock(1);

    size_label(square_stock_thickness);

    translate([square_stock_thickness, 0])
        size_label(square_stock_width, rotation=-90);
    translate([square_stock_thickness / 2, 0, -size_label_height() * 1.5])
        rotate([90, 0, 0])
        text("LEG / ARM",
             size=square_stock_thickness,
             halign="center",
             valign="top");
}

module dowel_example() {
    long_dowel_color() dowel(1);

    translate([-dowel_radius(), 0]) size_label(dowel_diameter);

    translate([0, 0, -size_label_height() * 1.5])
        rotate([90, 0, 0])
        text("DOWEL",
             size=square_stock_thickness,
             halign="center",
             valign="top");
}

leg_arm_example();
translate([square_stock_thickness * 8, 0]) dowel_example();

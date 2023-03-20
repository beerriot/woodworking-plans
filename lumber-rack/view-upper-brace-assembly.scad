// brace assembly
//cmdline: --imgsize=512,512
include <../common/echo-camera-arg.scad>
use <../common/labeling.scad>

include <params.scad>
use <lumber-rack.scad>

$vpr=[ 75.30, 0.00, 239.60 ];
$vpt=[ 135.62, -24.57, 74.64 ];
$vpf=22.50;
$vpd=389.82;

module components() {
    left_side();
    translate([0, stock_breadth*10, 0])
        right_side();
    translate([0, stock_breadth*5, 0]) {
        lower_brace();
        upper_brace();
    }
}

module dowel_hole() {
    color("black")
        rotate([90, 0, 0])
        cylinder(stock_breadth*100, d=dowel_diameter, center=true);
}

module dowel_and_guide() {
    translate([0, -stock_breadth*4, 0])
        color("red")
        rotate([90, 0, 0])
        cylinder(stock_breadth*2.5, d=dowel_diameter, center=true);
    translate([0, stock_breadth*6, 0])
        color("black")
        rotate([90, 0, 0])
        cylinder(stock_breadth*20, d=0.1, center=true);

}

module place_dowels() {
    place_side_dowels() children();
    translate([0,pair_separation+stock_breadth*10,0])
        mirror([0,1,0]) {
        place_side_dowels() children();
    }
}

module place_side_dowels() {
    lower_height = shelf_height[2]-shelf_thickness[2]/2;
    lower_offset = lower_height*sin(frame_angle)+stock_breadth*3/2;
    upper_height = lower_height+pair_separation-stock_breadth;
    upper_offset = upper_height*sin(frame_angle)+stock_breadth*3/2;
    translate([lower_offset,0,lower_height])
        children();
    translate([upper_offset,0,upper_height])
        children();
}

difference() {
    components();

    place_dowels() dowel_hole();
}

place_dowels() dowel_and_guide();

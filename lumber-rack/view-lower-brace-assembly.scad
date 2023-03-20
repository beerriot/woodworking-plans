// lower brace assembly
//cmdline: --imgsize=512,512
include <../common/echo-camera-arg.scad>
use <../common/labeling.scad>

include <params.scad>
use <lumber-rack.scad>

$vpr=[ 73.20, 0.00, 245.20 ];
$vpt=[ 124.50, -3.53, -7.57 ];
$vpf=22.50;
$vpd=403.04;

module components() {
    left_side();
    translate([0, stock_breadth*10, 0])
        right_side();
    translate([0, stock_breadth*5, 0]) {
        lower_brace();
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
    dowel_height = (shelf_height[0]-stock_breadth)/2;
    rear_offset = lower_brace_thickness*sqrt(2)/2;
    front_offset = cross_brace_length(lower_brace_thickness)/sqrt(2);
    translate([rear_offset,0,dowel_height])
        children();
    translate([front_offset,0,dowel_height])
        children();
}
difference() {
    components();

    place_dowels() dowel_hole();
}

place_dowels() dowel_and_guide();

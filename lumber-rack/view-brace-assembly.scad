// brace assembly
//cmdline: --imgsize=512,512
include <../common/echo-camera-arg.scad>
use <../common/labeling.scad>

include <params.scad>
use <lumber-rack.scad>

$vpr=[ 75.30, 0.00, 35.00 ];
$vpt=[ 106.63, -101.46, 67.15 ];
$vpf=22.50;
$vpd=80.26;

module components() {
    translate([0, stock_breadth*6, 0])
        rotate([0, -45, 0])
        cross_stile(upper_brace_thickness,
                    cross_brace_length(upper_brace_thickness));
    translate([0, 0, (cross_brace_length(upper_brace_thickness)+upper_brace_thickness)/sqrt(2)])
        rotate([180, 45, 0])
        cross_stile(upper_brace_thickness,
                    cross_brace_length(upper_brace_thickness));
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
    halfhyp = (cross_brace_length(upper_brace_thickness)+upper_brace_thickness)
        /(2*sqrt(2));
    translate([halfhyp-(upper_brace_thickness*sqrt(2)/3),
               0,
               halfhyp])
        children();
    translate([halfhyp-(upper_brace_thickness*2*sqrt(2)/3),
               0,
               halfhyp])
        children();
}

difference() {
    components();

    place_dowels() dowel_hole();
}

place_dowels() dowel_and_guide();

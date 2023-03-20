// Leg dado alignment
//cmdline: --projection=o --imgsize=1024,256
include <../common/echo-camera-arg.scad>
use <../common/labeling.scad>

include <params.scad>
use <lumber-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 62.94, -156.15, 18.53 ];
$vpf=22.50;
$vpd=160.31;

element_size = [height, stock_breadth,
                front_leg_thickness+rear_leg_thickness+stock_breadth];

key([["left legs", undef, element_size],
     ["right legs", undef, element_size]]) {
    left_legs();
    right_legs();
}

module left_legs() {
    rotate([180, 0, 0]) leg(front_leg_thickness);
    translate([0, 0, front_leg_thickness+stock_breadth])
        rotate([180, 0, 0])
        leg(rear_leg_thickness);
}

module right_legs() {
    translate([0, 0, rear_leg_thickness]) {
        mirror([0, 1, 0])
            leg(rear_leg_thickness);
        translate([0, 0, front_leg_thickness+stock_breadth])
            mirror([0, 1, 0])
            leg(front_leg_thickness);
    }
}

// Leg end alignment
//cmdline: --projection=o --imgsize=1024,512
include <../common/echo-camera-arg.scad>
use <../common/labeling.scad>

include <params.scad>
use <lumber-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 11.64, -156.15, 11.39 ];
$vpf=22.50;
$vpd=70.25;


module yes_legs() {
    difference() {
        translate([0, anti_dado_depth(), 0])
            leg(front_leg_thickness, dados=false);

        translate([height*3/5, stock_breadth/2, -front_leg_thickness/2])
            elision([leg_length(front_leg_thickness),
                     stock_breadth, front_leg_thickness]);
    }

    translate([-leg_length(front_leg_thickness)*4/5+stock_breadth, 0, 0])
        difference() {
        translate([0, anti_dado_depth(), 0])
            leg(front_leg_thickness, dados=false);

        translate([height*2/5, stock_breadth/2, -front_leg_thickness/2])
            elision([leg_length(front_leg_thickness),
                     stock_breadth, front_leg_thickness]);
    }

    angle_label(5, -90, front_leg_thickness);
    translate([leg_length(front_leg_thickness)/5+stock_breadth, 0, -front_leg_thickness])
        angle_label(5, 90, front_leg_thickness);
}

module no_legs() {
    translate([0, 0, front_leg_thickness])
        difference() {
        translate([0, anti_dado_depth(), 0])
            leg(front_leg_thickness, dados=false);

        translate([height*3/5, stock_breadth/2, -front_leg_thickness/2])
            elision([leg_length(front_leg_thickness),
                     stock_breadth, front_leg_thickness]);
    }

    translate([-leg_length(front_leg_thickness)*4/5+stock_breadth, 0, 0])
        difference() {
        translate([0, anti_dado_depth(), 0])
            mirror([0,0,1]) leg(front_leg_thickness, dados=false);

        translate([height*2/5, stock_breadth/2, front_leg_thickness/2])
            elision([leg_length(front_leg_thickness),
                     stock_breadth, front_leg_thickness]);
    }
}

key([["no", undef, [height, stock_breadth, front_leg_thickness]],
     ["yes", undef, [height, stock_breadth, front_leg_thickness]]]) {
    no_legs();
    translate([0, 0, front_leg_thickness]) yes_legs();
}

// Example of a key
//cmdline: --projection=o --imgsize=600,400
include <../common/echo-camera-arg.scad>

use <view-book-third-angle.scad>
use <../common/labeling.scad>

$vpt=[ 4.05, 1.57, 12.00 ];
$vpr=[ 90.00, 0.00, 0.00 ];
$vpd=68.11;
$vpf=22.50;

$fs=0.1;

pencil_radius = 1;
pencil_diameter = pencil_radius * 2;
eraser_length = 2;
body_length = 10;
point_length = 2;
lead_ratio = 0.2;
pencil_length = eraser_length + body_length + point_length;

module pencil() {
    rotate([0, 90, 0]) {
        //eraser
        color("#ffdddd") cylinder(h=eraser_length, r=pencil_radius);
        translate([0, 0, eraser_length]) {
            //main body
            color("#ffff55") cylinder(h=body_length, r=pencil_radius);
            //ferrule
            color("#cccccc")
                cylinder(h=eraser_length, r=pencil_radius*1.05, center=true);
            translate([0, 0, body_length]) {
                //wood point
                color("#bbaa66")
                    cylinder(h=point_length * (1-lead_ratio),
                             r1=pencil_radius,
                             r2=pencil_radius * lead_ratio);
                color("#333333")
                    translate([0, 0, point_length * (1-lead_ratio)])
                    cylinder(h=point_length * lead_ratio,
                             r1=pencil_radius * lead_ratio,
                             r2=0.01);
            }
        }
    }
}

key([["PENCIL", 3, [pencil_length, pencil_diameter, pencil_diameter]],
     ["BOOK", 1, [10,5,15]]]) {
    third_angle([pencil_length, pencil_diameter, pencil_diameter],
                front_labels=undef,
                spacing=pencil_length * 0.1) {
        translate([0, 0, pencil_radius]) pencil();
        union() {} union() {} // no labels for this example
    }
    translate([0.65, 0]) third_angle([10, 5, 15], front_labels=[0,0,0]) {
        book();
        union() {} union() {} union() {}
    }
}

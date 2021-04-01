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

pencilRadius = 1;
pencilDiameter = pencilRadius * 2;
eraserLength = 2;
bodyLength = 10;
pointLength = 2;
leadRatio = 0.2;
pencilLength = eraserLength + bodyLength + pointLength;

module pencil() {
    rotate([0, 90, 0]) {
        //eraser
        color("#ffdddd") cylinder(h=eraserLength, r=pencilRadius);
        translate([0, 0, eraserLength]) {
            //main body
            color("#ffff55") cylinder(h=bodyLength, r=pencilRadius);
            //ferrule
            color("#cccccc") cylinder(h=eraserLength, r=pencilRadius*1.05, center=true);
            translate([0, 0, bodyLength]) {
                //wood point
                color("#bbaa66") cylinder(h=pointLength * (1-leadRatio), r1=pencilRadius, r2=pencilRadius * leadRatio);
                color("#333333") translate([0, 0, pointLength * (1-leadRatio)]) cylinder(h=pointLength * leadRatio, r1=pencilRadius * leadRatio, r2=0.01);
            }
        }
    }
}

key([keyChildInfo("PENCIL", 3, [pencilLength, pencilDiameter, pencilDiameter]),
     keyChildInfo("BOOK", 1, [10,5,15])]) {
         thirdAngle([pencilLength, pencilDiameter, pencilDiameter],
                    frontLabels=undef,
                    spacing=pencilLength * 0.1) {
             translate([0, 0, pencilRadius]) pencil();
             union() {} union() {} // no labels for this example
         }
         translate([0.65, 0]) thirdAngle([10, 5, 15], frontLabels=[0,0,0]) {
             book();
             union() {} union() {} union() {}
         }
}

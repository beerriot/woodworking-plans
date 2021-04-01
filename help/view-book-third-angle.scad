// Example third-angle
//cmdline: --projection=o --imgsize=400,400
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

$vpt=[ 6.15, 1.76, 9.38 ];
$vpr=[ 90.00, 0.00, 0.00 ];
$vpd=50.44;
$vpf=22.50;

$fs=0.1;

coverWidth=10;
coverHeight=15;
coverThickness=0.3;

pagesInset=0.3;
pagesHeight=coverHeight - pagesInset*2;
pagesWidth=coverWidth - pagesInset;
pagesThickness=2;

bookThickness=coverThickness*2 + pagesThickness;

module coverColor() {
    color("#0000dd") children();
}

module textColor() {
    color("#66aa66") children();
}

module pagesColor() {
    color("#ffffee") children();
}

module cover() {
    coverColor() cube([coverWidth,coverThickness,coverHeight]);
}

module pages() {
    pagesColor() union() {
        translate([0,pagesThickness/2]) scale([0.5,1,1]) cylinder(h=pagesHeight, r=pagesThickness/2);
        cube([pagesWidth, pagesThickness, pagesHeight]);
    }
}

module spine() {
    coverColor() scale([0.5,1,1]) difference() {
        cylinder(h=coverHeight, r=bookThickness/2);
        translate([0,0,-0.01]) cylinder(h=coverHeight+0.02, r=pagesThickness/2);
        translate([0, -(bookThickness/2 + 0.1), -0.1]) cube([bookThickness + 0.2, bookThickness + 0.2, coverHeight+0.2]);
    }
}

module book() {
    cover();
    translate([0,coverThickness]) {
        translate([0, 0, pagesInset]) pages();
        translate([0, pagesThickness/2]) spine();
        translate([0,pagesThickness]) cover();
    }

    textColor() {
        translate([coverWidth/2, 0.4, coverHeight/2]) rotate([90, 0, 0]) text("front", size=2, halign="center");
        translate([coverWidth/2, bookThickness/2, coverHeight-0.6]) text("top", size=1, halign="center", valign="center");
        translate([coverWidth-0.6, bookThickness/2, coverHeight/2]) rotate([0, 90, 0]) text("right", size=1, halign="center", valign="center");
    }
}

thirdAngle([coverWidth, bookThickness, coverHeight], frontLabels=[0,0,0]) {
    book();
    
    union() {}
    
    union() {}
    
    union() {}
}

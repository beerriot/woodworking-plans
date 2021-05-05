// Example third-angle
//cmdline: --projection=o --imgsize=400,400
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

$vpt=[ 6.15, 1.76, 9.38 ];
$vpr=[ 90.00, 0.00, 0.00 ];
$vpd=50.44;
$vpf=22.50;

$fs=0.1;

cover_width=10;
cover_height=15;
cover_thickness=0.3;

pages_inset=0.3;
pages_height=cover_height - pages_inset*2;
pages_width=cover_width - pages_inset;
pages_thickness=2;

book_thickness=cover_thickness*2 + pages_thickness;

module cover_color() {
    color("#0000dd") children();
}

module text_color() {
    color("#66aa66") children();
}

module pages_color() {
    color("#ffffee") children();
}

module cover() {
    cover_color() cube([cover_width,cover_thickness,cover_height]);
}

module pages() {
    pages_color() union() {
        translate([0,pages_thickness/2])
            scale([0.5,1,1])
            cylinder(h=pages_height, r=pages_thickness/2);
        cube([pages_width, pages_thickness, pages_height]);
    }
}

module spine() {
    cover_color() scale([0.5,1,1]) difference() {
        cylinder(h=cover_height, r=book_thickness/2);

        translate([0,0,-0.01])
            cylinder(h=cover_height+0.02, r=pages_thickness/2);
        translate([0, -(book_thickness/2 + 0.1), -0.1])
            cube([book_thickness + 0.2,
                  book_thickness + 0.2,
                  cover_height+0.2]);
    }
}

module book() {
    cover();
    translate([0,cover_thickness]) {
        translate([0, 0, pages_inset]) pages();
        translate([0, pages_thickness/2]) spine();
        translate([0,pages_thickness]) cover();
    }

    text_color() {
        translate([cover_width/2, 0.4, cover_height/2])
            rotate([90, 0, 0])
            text("front", size=2, halign="center");
        translate([cover_width/2, book_thickness/2, cover_height-0.6])
            text("top", size=1, halign="center", valign="center");
        translate([cover_width-0.6, book_thickness/2, cover_height/2])
            rotate([0, 90, 0])
            text("right", size=1, halign="center", valign="center");
    }
}

third_angle([cover_width, book_thickness, cover_height],
            front_labels=[0,0,0]) {
    book();

    union() {}

    union() {}

    union() {}
}

// Leg assembly
//cmdline: --imgsize=512,1024
include <../common/echo-camera-arg.scad>
use <../common/labeling.scad>

include <params.scad>
use <lumber-rack.scad>

$vpr=[ 69.70, 0.00, 50.40 ];
$vpt=[ 121.30, -59.66, 136.55 ];
$vpf=22.50;
$vpd=359.55;

module components() {
    rotate([0, frame_angle-90, 0]) leg(rear_leg_thickness);

    translate([front_leg_thickness/cos(frame_angle)+2*height*sin(frame_angle),
               stock_breadth*20, 0])
        rotate([180, -frame_angle-90, 0])
        leg(front_leg_thickness);

    translate([0, stock_breadth*10, 0]) {
        foot();


        for (i = [1:len(shelf_height)-1]) {
            translate([0, 0, shelf_height[i]-shelf_thickness[i]])
                shelf(shelf_height[i], shelf_thickness[i]);
        }
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
    translate([0, stock_breadth*11, 0])
        color("black")
        rotate([90, 0, 0])
        cylinder(stock_breadth*30, d=0.1, center=true);

}

module place_dowels() {
    for (i = [0:len(shelf_height)-2]) {
        // rear dowels
        translate([shelf_height[i]*tan(frame_angle)+rear_leg_thickness*2/3,
                   0,
                   shelf_height[i]-shelf_thickness[i]/3])
            children();
        translate([shelf_height[i]*tan(frame_angle)+rear_leg_thickness/3,
                   0,
                   shelf_height[i]-shelf_thickness[i]*2/3])
            children();

        // front dowels
        translate([shelf_height[i]*tan(frame_angle)
                   +(height-shelf_height[i])*2*tan(frame_angle)
                   +front_leg_thickness/3,
                   0,
                   shelf_height[i]-shelf_thickness[i]/3])
            children();
        translate([shelf_height[i]*tan(frame_angle)
                   +(height-shelf_height[i])*2*tan(frame_angle)
                   +front_leg_thickness*2/3,
                   0,
                   shelf_height[i]-shelf_thickness[i]*2/3])
            children();
    }

    // top dowels
    lasti = len(shelf_height)-1;
    translate([shelf_height[lasti]*tan(frame_angle)+rear_leg_thickness*2/3,
               0,
               shelf_height[lasti]-shelf_thickness[lasti]/3])
        children();
    translate([shelf_height[lasti]*tan(frame_angle)+rear_leg_thickness/3,
               0,
               shelf_height[lasti]-shelf_thickness[lasti]*2/3])
        children();
}

difference() {
    components();

    place_dowels() dowel_hole();
}

place_dowels() dowel_and_guide();

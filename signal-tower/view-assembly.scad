// The assembled view.
//cmdline: --imgsize=2048,1536
include <../common/echo-camera-arg.scad>

use <signal-tower.scad>

$vpt = [ -5.21, 20.05, 103.88 ];
$vpr = [ 74.60, 0.00, 14.70 ];
$vpd = 640.56;
$vpf = 22.50;

tower($use_finish_colors=true);
ground();

// Add a call to this module to put an overly simplified version of
// Starlink's satellite dish on top of the tower.
starlink_dish_diameter = 23.5; // inches
starlink_dish_depth = 3; // inches
starlink_pipe_diameter = 1.5; //inches
starlink_pipe_length = 16; // inches
starlink_pipe_inset = 2; // inches
module example_starlink_dish() {
    color("#eeeeee")
        translate([0,
                   0,
                   assembled_height()
                   + starlink_pipe_length
                   - starlink_pipe_inset])
        rotate([90, 0, 0])
        cylinder(h=starlink_dish_depth, d=starlink_dish_diameter);

    color("#000000")
        translate([0, 0, assembled_height() - starlink_pipe_inset])
        cylinder(h=starlink_pipe_length, d=starlink_pipe_diameter);
}

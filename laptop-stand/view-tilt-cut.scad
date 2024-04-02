//cmdline: --imgsize=1024,640
include <../common/echo-camera-arg.scad>

use <laptop-stand.scad>
include <params.scad>

$vpr=[ 89.50, 0.00, 337.40 ];
$vpt=[ 14.56, 9.04, 4.55 ];
$vpf=22.50;
$vpd=54.08;

foot(cut_groove=false, cut_fancy_ends=false);
translate([0, 0, foot_width + wood_thickness])
riser_view_tilt_cut();

// reused in later steps
module riser_view_tilt_cut() {
    riser(cut_tongues=false, cut_fancy_end=false);
}

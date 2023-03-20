// Third Angle view of Assembly
//cmdline: --projection=o --imgsize=1250,2048
include <../common/echo-camera-arg.scad>

include <params.scad>
use <lumber-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 68.45, -204.62, 122.26 ];
$vpf=22.50;
$vpd=664.63;

module assembly_key() {
    third_angle([depth, pair_separation+stock_breadth, height]) {
        translate([anti_dado_depth(), depth, 0])
            rotate([0, 0, -90]) assembly();

        union() {
            size_label(pair_separation+stock_breadth+anti_dado_depth()*2);

            for(i = [0 : len(shelf_height)-1]) {
                translate([2*stock_breadth
                           + i * pair_separation / len(shelf_height),
                           0, 0])
                    size_label(shelf_height[i], rotation=-90);
            }
        }

        ta_right_side(depth) {
            size_label(depth);
            translate([depth, 0]) {
                size_label(height, rotation=-90);
                angle_label(5, 90, size=height/3);
            }
            for (i = [0 : len(shelf_height)-1]) {
                translate([0, 0, shelf_height[i]])
                    size_label(depth - height*sin(frame_angle)
                               - (height-shelf_height[i])*sin(frame_angle)
                               - (i < len(shelf_height)-1
                                  ? (front_leg_thickness/cos(frame_angle))
                                  : 0),
                               over=true);
            }
        }

        ta_top_side(height) {}
    }
}

assembly_key();

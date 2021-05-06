// Label number of vial sizes available.
//cmdline: --projection=o --imgsize=2048,1280
include <../common/echo-camera-arg.scad>

include <params.scad>
use <perfume-display.scad>

$vpr = [ 0.00, 0.00, 0.00 ];
$vpt = [ 20, 10.26, 3.58 ];
$vpd = 65.64;

assembly();
fill_holes_for_orthographic();

positions = vial_positions();

function count_vials_of_size(size, count=0, y=[plank_size.y, 0], i=0) =
    (i >= len(positions))
    ? [size, count, y]
    : ((size == positions[i][1])
       ? count_vials_of_size(size,
                             count=count + 1,
                             y=[min(y[0], positions[i][0].y),
                                max(y[0], positions[i][0].y)],
                             i=i + 1)
       : count_vials_of_size(size, count, y, i+1));

counts = [ for (v = vials) count_vials_of_size(v[0]) ];
half_row = row_offset(1).y / 2;
bottom_inset = static_border().y + dynamic_border().y;

echo("searching ", len(positions), "vial positions");
echo("position 0:", positions[0]);

color([0,0,0,0.8])
translate([plank_size.x + border.x, bottom_inset, plank_size.z]) {
    for (c = counts) {
        echo(c[1], "vials of size", c[0], "between", c[2]);

        translate([0, c[2][0] - half_row]) cube([3, 0.1, 0.1]);
        translate([0, c[2][1] + half_row]) cube([3, 0.1, 0.1]);

        translate([border.x, (c[2][0] + c[2][1]) / 2])
            text(str(c[1], " holes ", c[0], "cm in diameter"),
                 valign="center",
                 size=half_row*0.75);
    }
}

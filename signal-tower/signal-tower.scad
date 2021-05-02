use <../common/labeling.scad>

$fs = 0.1;
$fa = 5;

// All units in inches
leg_length = 12 * 12;
// From ground
leg_angle = 75;
leg_size = [leg_length, 3.5, 3.5];

pipe_diameter = 2;
pipe_length = 12 * 10;

tower_height = leg_length * sin(leg_angle);
tower_radius = (leg_length * cos(leg_angle)
                + pipe_diameter / 2);

brace_height = tower_height * 2 / 3;

brace_thickness = 1.5;
brace_length_rear =
    (leg_size.y / 2) / cos(30)
    + (brace_thickness + leg_size.y / 2) * tan(30);
brace_length =
    // leg span without pipe shift, because shift actually makes the
    // triangle taller, though we're concerned with the end of the
    // legs as the height
    (((tower_height - brace_height) / tower_height)
     * (tower_radius - pipe_diameter / 2))
    // account for pipe shift in leg span
    + pipe_diameter / 2
    // width of leg at angle
    + leg_size.z / sin(leg_angle)
    + brace_length_rear;
brace_size = [brace_length, brace_thickness, 5.5];

module leg() {
    color("#669900")
        translate([pipe_diameter / 2, -leg_size.y / 2, tower_height])
        rotate([0, leg_angle, 0])
        cube(leg_size);
}

module pipe() {
    color("#cccccc") cylinder(h=pipe_length, d=pipe_diameter);
}

module brace() {
    translate([-brace_length_rear, leg_size.y / 2, brace_height])
    difference() {
        cube(brace_size);

        translate([brace_length, 0, 0])
            rotate([0, leg_angle, 0])
            translate([-brace_length / 2, -brace_size.y * 0.05, 0])
            cube(brace_size * 1.1);


        translate([0, brace_size.y, 0])
            rotate([0, 0, -60])
            translate([-brace_length / 2,
                       -brace_size.y * 1.1,
                       -brace_size.z * 0.05])
            cube(brace_size * 1.1);
    }
}

module tower() {
    leg(); brace();
    rotate([0, 0, 120]) { leg(); brace(); }
    rotate([0, 0, -120]) { leg(); brace(); }
    translate([0, 0, brace_height]) pipe();
}

module ground() {
    color("#cccc0099")
        translate([0, 0, -1])
        cylinder(r=tower_radius * 3, h=1);
}

tower();
//ground();

sizeLabel(tower_radius, over=true);
sizeLabel(tower_height, rotation=-90);
sizeLabel(tower_height + pipe_length - (tower_height - brace_height),
          rotation=-90,
          over=true);
translate([-brace_length_rear, leg_size.y / 2 + brace_thickness, brace_height]) sizeLabel(brace_length);

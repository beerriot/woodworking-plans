// Height of the tower without the pipe.
wood_tower_height = 11 * 12 + 5.5;

// Measures from the center of the pole to the outer edge of the
// center of the leg.
wood_tower_base_radius = 3 * 12 + 5.45;

// Thickness lies along the radius.
leg_thickness = 3.5;
// Width is tangent to the radius.
leg_width = leg_thickness;

// Outer diameter of the pipe.
// pipe is only 1 29/32, but coupler is 2 5/32; bumping to 2 1/4 to make space for sliding
pipe_diameter = 2.25;
// Length of the pipe.
pipe_length = 10 * 12;

// Heights at which the bottoms of the braces will be. Note that the
// highest brace will also be the highest point the pipe can be
// raised.
brace_elevations = [2.5 * 12, 8.5 * 12]; //[3 * 12, 9 * 12];

// The size of the brace material, top to bottom.
brace_height = 5.5;

// The size of the brace material, tangent to the tower radius.
brace_thickness = 1.5;

// Diameter of the shafts of the bolts securing the braces to the legs.
bolt_diameter = 0.4375;

leg_color = "#667700";
pipe_color = "#cccccc";
brace_color = "#778800";

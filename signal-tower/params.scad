// [Length, Width, Thickness] of the legs
leg_size = [12 * 12 + 0.25, 3.5, 3.5];

// Angle of each leg, relative to the ground
leg_angle = 75;

// [(Length ignored), Thickness, Width] of the brace material
brace_profile = [0, 1.5, 5.5];

// How far above the ground the bottom of each brace is.
brace_elevations = [2.5 * 12, 8.5 * 12];

// [Length, Width, Height] of clamp material
clamp_layer_size = [7.5, 7.5, 0.75];

// [OD, ID, Length] of pipe
pipe_size = [1.9, 1.5, 10 * 12];

// Bolts used to hold legs to braces
leg_bolt_diameter = 3/8;

// Wrench size for the leg-brace bolts
leg_bolt_head_size = 9/16;

// Bolts used to clamp pipe to braces
clamp_bolt_diameter = 3/8;

// Wrench size for the pipe-brace bolts
clamp_bolt_head_size = 9/16;

// Thickness of metal for the hangers connecting the braces to each other.
hanger_thickness = 1/16;

hanger_screw_size = [1/4, 1/8, brace_profile.y * 0.75];

leg_color = "#ee9900";
pipe_color = "#cccccc";
brace_color = "#55bbee";
clamp_color = "#cc77aa";
hanger_color = "#cccccc";
hardware_color = "#cccccc";

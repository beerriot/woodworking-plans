// [Length, Width, Thickness] of the legs
// Inches: [12 * 12 + 0.25, 3.5, 3.5]
leg_size = [366.4, 8.89, 8.89];

// Angle of each leg, relative to the ground
leg_angle = 75;

// [(Length ignored), Thickness, Width] of the brace material
// Inches: [0, 1.5, 5.5]
brace_profile = [0, 3.81, 13.97];

// How far above the ground the bottom of each brace is.
// Inches: [2.5 * 12, 8.5 * 12]
brace_elevations = [76.2, 259.08];

// [Length, Width, Height] of clamp material
// Inches: [7.5, 7.5, 0.75]
clamp_layer_size = [19.05, 19.05, 1.91];

// [OD, ID, Length] of pipe
// Inches: [1.9, 1.5, 10 * 12]
pipe_size = [4.83, 3.81, 304.8];

// Bolts used to hold legs to braces
// Inches: 3/8
leg_bolt_diameter = 0.95;

// Wrench size for the leg-brace bolts
// Inches: 9/16
leg_bolt_head_size = 1.43;

// Bolts used to clamp pipe to braces
// Inches: 3/8
clamp_bolt_diameter = 0.95;

// Wrench size for the pipe-brace bolts
// Inches: 9/16
clamp_bolt_head_size = 1.43;

// Outer diameter of the barrel of the T-nut in the pipe clamp
// Inches: 7/16
clamp_t_nut_diameter = 1.11;

// Thickness of metal for the hangers connecting the braces to each other.
// Inches: 1/16
hanger_thickness = 0.16;

// Screws used to attach hangers to braces. [Head OD, Shaft ID, Length]
// Inches: [1/4, 1/8, brace_profile.y * 0.75]
hanger_screw_size = [0.64, 0.32, brace_profile.y * 0.75];

leg_color = "#ee9900";
pipe_color = "#cccccc";
brace_color = "#55bbee";
clamp_color = "#cc77aa";
hanger_color = "#cccccc";
hardware_color = "#cccccc";
ground_color = "#66cc0099";

finish_wood_color = "#dd9966";
finish_metal_color = "#cccccc";

// Typical counter-top height in the US is 36 inches. Rounding down to 91cm.
height = 90;

// Distance from the outside of the left wall to the outside of the
// right wall.
width = 45;

// Distance from the counter side of the tower to the opposite edge of
// the feet.
bottom_depth = 45;

// Distance from the counter side of the tower to the opposite edge of
// the standing platform.
platform_depth = 30;

// Thickness of the wood. All components are made from the same stock.
thickness = 1.9;

// Heights at which the front step can be set. Code assumes that the
// first element is the lowest height, and the last element is the
// highest.
front_step_heights = [10, 20];

// Heights at which the platform can be set. Code assumes that the
// first element is the lowest height, and the last element is the
// highest.
platform_heights = [25, 35, 45, 55];

// [length, width] of handholds on the front
handhold_size = [10, 3.5];

// centers of the top half-circle of each handhold
handhold_heights = [45, 60, 75];

// Outer diameter of the threaded inserts for the platform and front step.
threaded_insert_od = 0.6;

// Length of the threaded insert.
threaded_insert_depth = 1;

// Diameter of the head of the bolts holding the platform and step.
bolt_head_diameter = 1.25;

// Thickness of the head of the bolts holding the platform and step.
bolt_head_thickness = 0.1;

// Colors for the component and assembly diagrams
side_color = "#ffff99";
dado_color = "#dddd77";
rabbet_color = dado_color;
groove_color = rabbet_color;

platform_color = "#9999ff";
front_step_color = "#99ffff";

narrow_support_color = "#dd7799";
wide_support_color = "#ffaaff";
safety_rail_color = "#cc33dd";

bolt_hole_color = "#333333";

threaded_insert_color = "#999933";
bolt_color = "#666600";
screw_color = "#009966";
finish_washer_color = "#00ff99";

// Colors for the preview assembly
finish_wood_color = "#ffffdd";
finish_screw_color = "#cccc99";
finish_bolt_color = "#999933";

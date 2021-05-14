include <math_funcs.scad>

// minimum distance to move an edge to avoid face interference when
// slicing
$err = 0.01;

// Use this function to help encapuslate the shifts that are required
// to avoid rendering conflicts. For example, the two rectangular
// solids in this difference have faces at exactly the same space:
//
// ```
// difference() {
//    cube([3,2,1]);
//    translate([1, 0, 0]) cube([1,1,1]);
// }
// ```
//
// To resolve the conflicts on the front, top, and bottom faces, add
// "a little" in Y, and "a little more" in Z, then shift back and
// down, to put the smaller cube's faces outside of the larger solid's
// (while keeping the "cutting" faces in the same place):
//
// ```
// difference() {
//    cube([3,2,1]);
//    translate([1, 0, 0] - err([0, 1, 1])) cube([1,1,1] + err([0, 1, 2]));
// }
// ```
//
// Override the special variable `$err` if the default 0.01 shift is
// not enough for your use case.
function err(vec) = $err * vec;

// This is "cube" with a tool to help avoid rendering conflicts.  Use
// errs to make pieces for slicing out of other pieces. The elements
// of the vector apply to [x, y, z]. Each value should be 0, 1, -1, or
// 2.
//   0: make the dimension exactly as specified
//   1: add `err` to the dimension
//  -1: add `err` to the dimension, but also shift the object -err
//      (i.e. add err to the zero end of that dimension)
//   2: add `2*err` to the dimension, but also shift the object -err
//      (i.e. add err to each end)
// Using errs prevents the need for +/-err to appear in object
// creation code.
module square_stock(size, errs=[0,0,0]) {
    // If adding err to both ends or toward the negative axis, shift
    // err in the negative axis direction. This makes the cube run
    // from -err to size.d+err for 2 or to size.d for -1.
    translate([ for (d = errs) (d == 2 || d == -1 ? -$err : 0) ])
        cube(size + err(vabs(errs)));
}

// This is "cylinder" with two features:
//   1. length=x (not height=z, as with cylinder)
//   2. errs vec for less noisy slicing
//
// See `square_stock` for description of errs. errs[0] applies to
// length.  errs[1] applies to radius, but does not shift position for
// -1 or 2.
module round_stock(length, radius, errs=[0,0]) {
    translate([errs.x == 2 || errs.x == -1 ? -$err : 0, 0, 0])
    rotate([0, 90, 0])
    cylinder(length + ($err * abs(errs.x)),
             r = (radius + ($err * abs(errs[1]))));
}

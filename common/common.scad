// minimum distance to move an edge to avoid face interference when slicing
err = 0.01;

// This is "cube" with two features:
//   1. length=x, thickness=y, width=z
//   2. errs vec for less noisy slicing
//
// Use errs to make pieces for slicing out of other pieces. The elements of the
// vector apply to [length, thickness, width]. Each value should be 0, 1, -1, or 2.
//   0: make the dimension exactly as specified
//   1: add `err` to the dimension
//  -1: add `err` to the dimension, but also shift the object -err
//      (i.e. add err to the zero end of that dimension)
//   2: add `2*err` to the dimension, but also shift the object -err
//      (i.e. add err to each end)
// Using errs prevents the need for +/-err to appear in object creation code.
module squareStock(length, thickness, width, errs=[0,0,0]) {
    translate([errs.x == 2 || errs.x == -1 ? -err : 0,
               errs.y == 2 || errs.y == -1 ? -err : 0,
               errs.z == 2 || errs.z == -1 ? -err : 0])
        cube([length + (err * abs(errs.x)),
              thickness + (err * abs(errs.y)),
              width + (err * abs(errs.z))]);
}

// This is "cylinder" with two features:
//   1. length=x (not height=z, as with cylinder)
//   2. errs vec for less noisy slicing
//
// See `squareStock` for description of errs. errs[0] applies to length.
// errs[1] applies to radius, but does not shift position for -1 or 2.
module roundStock(length, radius, errs=[0,0]) {
    translate([errs.x == 2 || errs.x == -1 ? -err : 0, 0, 0])
    rotate([0, 90, 0])
    cylinder(length + (err * abs(errs.x)),
             r = (radius + (err * abs(errs[1]))));
}
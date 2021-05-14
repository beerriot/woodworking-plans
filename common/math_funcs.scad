// Useful Math Functions

// Rotate vec3 `vector`, `angle` degrees around the Z axis.
function rotatez(angle, vector) =
    vector *
    [[ cos(angle), sin(angle), 0],
     [-sin(angle), cos(angle), 0],
     [          0,          0, 1]];

// Test
assert([0, 1, 3] == rotatez(90, [1, 0, 3]));

// Rotate vec3 `vector`, `angle` degrees around the X axis.
function rotatex(angle, vector) =
    vector *
    [[1,           0,          0],
     [0,  cos(angle), sin(angle)],
     [0, -sin(angle), cos(angle)]];

// Test
assert([3, 0, 1] == rotatex(90, [3, 1, 0]));

// Rotate vec3 `vector`, `angle` degrees around the Y axis.
function rotatey(angle, vector) =
    vector *
    [[cos(angle), 0, -sin(angle)],
     [0,          1,           0],
     [sin(angle), 0,  cos(angle)]];

// Test
assert([1, 3, 0] == rotatey(90, [0, 3, 1]));

// Rotate vec3 `vector`, `axes.x` degrees around the X axis, `axes.y`
// degrees around the Y axis, and `axes.z` degrees around the Z
// axis. This is the function equivalent of the module `rotate`.
function rotate(axes, vec) =
    assert(len(axes) == 3, "rotate expects vec3 axes")
    assert(len(vec) == 3, "rotate expects vec3 vec")
    rotatez(axes.z,
            rotatey(axes.y,
                    rotatex(axes.x, vec)));

// Test
// start: [1, 2, 3]
//   90x: [1, -3, 2]
//   90y: [2, -3, -1]
//   90z: [3,  2, -1]
assert([3, 2, -1] == rotate([90, 90, 90], [1, 2, 3]));

// Visual Test: You should see a blue cube and a red sphere
// overlapping each other.
color("red") rotate([105,25,45]) translate([1, 2, 3]) {
    sphere(0.25);
}
color("blue") translate(rotate([105,25,45], [1, 2, 3])) {
    cube(0.35, center=true);
}

// Scale vec3 `vector` by the given amount of each component of axes.
function scale(axes, vec) =
    vec * [[axes.x, 0, 0], [0, axes.y, 0], [0, 0, axes.z]];

// Absolute value of each element in the vector.
function vabs(vec) =
    [ for (e = vec) abs(e) ];

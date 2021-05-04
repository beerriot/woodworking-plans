// Useful Math Functions

// Rotate vec3 `vector`, `angle` degrees around the Z axis.
function rotatez(angle, vector) =
    vector *
    [[ cos(angle), sin(angle), 0],
     [-sin(angle), cos(angle), 0],
     [          0,          0, 1]];

// Rotate vec3 `vector`, `angle` degrees around the X axis.
function rotatex(angle, vector) =
    vector *
    [[1,           0,          0],
     [0,  cos(angle), sin(angle)],
     [0, -sin(angle), cos(angle)]];

// Rotate vec3 `vector`, `angle` degrees around the Y axis.
function rotatey(angle, vector) =
    vector *
    [[cos(angle), 0, -sin(angle)],
     [0,          1,           0],
     [sin(angle), 0,  cos(angle)]];

// Rotate vec3 `vector`, `axes.x` degrees around the X axis, `axes.y`
// degrees around the Y axis, and `axes.z` degrees around the Z
// axis. This is the function equivalent of the module `rotate`.
function rotate(axes, vec) =
    assert(len(axes) == 3, "rotate expects vec3 axes")
    assert(len(vec) == 3, "rotate expects vec3 vec")
    rotatez(axes.z,
            rotatey(axes.y,
                    rotatex(axes.x, vec)));

// Scale vec3 `vector` by the given amount of each component of axes.
function scale(axes, vec) =
    vec * [[axes.x, 0, 0], [0, axes.y, 0], [0, 0, axes.z]];

// Absolute value of each element in the vector.
function vabs(vec) =
    [ for (e = vec) abs(e) ];

// This file supports the build process by converting a files $vp*
// settings to a --camera argument to be used at the commandline (see
// CAMERA_OPT in Makefile.common).

// Two ways to used this file:
//
//    include <../common/echo-camera-arg.scad>
//
// OR
//
//    use <../common/echo-camera-arg.scad>
//    echo(cameraArg());

// $vpt/r/d in a formatted --camera argument, for the build to use to
// avoid warnings about them overriding --autocenter and
// --viewall. Use this as:
//
//     echo(cameraArg());
//
// The echo can't be in here, because OpenSCAD expects to find a
// module, not a function, if the return value is ignored. That means
// it prints a warning about being unable to find a *module* named
// camerArg.
function cameraArg() =
    str("--camera=",
        $vpt[0],",",$vpt[1],",",$vpt[2],",",
        $vpr[0],",",$vpr[1],",",$vpr[2],",",
        $vpd);

// Doing the echo here means adding this to a file is a one-liner via
// include.
echo(cameraArg());

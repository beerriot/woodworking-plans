// Supporting bits for panel-build views. These views all show the
// left and right panels next to each other, with cabinet-side edges
// facing.

use <../common/labeling.scad>

include <params.scad>

// How much space between the panels.
center_space = sizeLabelHeight() * len(platform_heights);

// The viewpoint settings.
function panel_vpt() = [ height / 2, bottom_depth + center_space / 2, -17.52 ];
function panel_vpr() = [ 0.00, 0.00, -90 ];
function panel_vpd() = 277.20;

// These panels are lying on the Z=0 plane. The sizeLabel module
// expect to be shown next to things in the Y=0 plane. This module
// rotates the sizeLabel to face "up" instead of "forward".
module viewLabel() {
    rotate([-90, 0, -90]) children();
}

// Move everything to point relative to the bottom non-cabinet-side
// corner of the left panel (which is at the bottom left of the
// diagrams).
function leftOrigin() = [0, bottom_depth * 2 + center_space, 0];
module leftOrigin(zoffset=0) {
    translate(leftOrigin() + [0, 0, zoffset])
        children();
}

// Show a mirror of all children to the left of the
// children. (I.e. show a mirror of the right panel as the left
// panel.)
module showBothSides() {
    children();
    leftOrigin() mirror([0,1,0]) children();
}

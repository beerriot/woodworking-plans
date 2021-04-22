// Supporting bits for panel-build views

use <../common/labeling.scad>

include <params.scad>

center_space = sizeLabelHeight() * len(platform_heights);

function panel_vpt() = [ height / 2, bottom_depth + center_space / 2, -17.52 ];
function panel_vpr() = [ 0.00, 0.00, -90 ];
function panel_vpd() = 277.20;

module viewLabel() {
    rotate([-90, 0, -90]) children();
}

module leftOrigin(zoffset=0) {
    translate([0, bottom_depth * 2 + center_space, zoffset])
        children();
}

module showBothSides() {
    children();
    leftOrigin() mirror([0,1,0]) children();
}

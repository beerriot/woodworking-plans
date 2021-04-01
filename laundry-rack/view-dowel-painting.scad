// View of unpainted dowel ends
//cmdline: --projection=o --imgsize=800,400
include <../common/echo-camera-arg.scad>

use <laundry-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ -7.08, -108.00, 9.74 ];
$vpf=22.50;
$vpd=70.41;

space = dowelDiameter() + sizeLabelHeight();

module paint() {
    color([0.8, 0.8, 0.8, 0.9]) rotate([0, 0, -90])
        dowel(longDowelLength(), errs=[0.01, 0]);
}

key([keyChildInfo("LONG DOWEL", 4, [0, 0, space]),
     keyChildInfo("LONG DOWEL", nonPivotLongDowelCount(),
                  [0, 0, space]),
     keyChildInfo("SHORT DOWEL", shortDowelCount(),
                  [0, 0, space])]) {
    translate([0,0,sizeLabelHeight()]) {
        translate([0, 0, dowelRadius()]) {
            rotate([0, 0, -90]) longDowel();
            translate([doubleSquareStockThickness(), 0]) paint();
        }
        sizeLabel(doubleSquareStockThickness());
    }
    translate([0,0,sizeLabelHeight()]) {
        translate([0, 0, dowelRadius()]) {
            rotate([0, 0, -90]) longDowel();
            translate([squareStockThickness(), 0]) paint();
        }
        sizeLabel(squareStockThickness());
    }
    translate([0,0,sizeLabelHeight()]) {
        translate([0, 0, dowelRadius()]) {
            rotate([0, 0, -90]) shortDowel();
            translate([squareStockThickness(), 0]) paint();
        }
        sizeLabel(squareStockThickness());
    }
}

// View of unpainted dowel ends
//cmdline: --projection=o --imgsize=800,400

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

key([keyChildInfo("LONG DOWEL", 4, dowelDiameter(), space),
     keyChildInfo("LONG DOWEL", nonPivotLongDowelCount(),
                  dowelDiameter(), space),
     keyChildInfo("SHORT DOWEL", shortDowelCount(),
                  dowelDiameter(), space)]) {
    union() {
        rotate([0, 0, -90]) longDowel();
        translate([doubleSquareStockThickness(), 0]) paint();
        translate([0, 0, -dowelRadius()]) sizeLabel(doubleSquareStockThickness());
    }
    union() {
        rotate([0, 0, -90]) longDowel();
        translate([squareStockThickness(), 0]) paint();
        translate([0, 0, -dowelRadius()]) sizeLabel(squareStockThickness());
    }
    union() {
        rotate([0, 0, -90]) shortDowel();
        translate([squareStockThickness(), 0]) paint();
        translate([0, 0, -dowelRadius()]) sizeLabel(squareStockThickness());
    }
}

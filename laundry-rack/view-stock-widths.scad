// End-on views of the stock to be used.
//cmdline: --projection=o --imgsize=400,200

use <laundry-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 7.38, -124.10, -0.69 ];
$vpf=22.50;
$vpd=53.88;

module legArmExample() {
    translate([squareStockThickness(), 0, squareStockWidth()/2])
        rotate([0, 0, 90]) legColor() armLegStock(1);

    sizeLabel(squareStockThickness());

    translate([squareStockThickness(), 0])
        sizeLabel(squareStockWidth(), rotation=-90);
    translate([squareStockThickness()/2, 0, -sizeLabelHeight() * 1.5])
        rotate([90, 0, 0])
        text("LEG / ARM", size=squareStockThickness(), halign="center", valign="top");
}

module dowelExample() {
    longDowelColor() dowel(1);

    translate([-dowelRadius(), 0]) sizeLabel(dowelDiameter());

    translate([0, 0, -sizeLabelHeight() * 1.5]) rotate([90, 0, 0])
        text("DOWEL", size=squareStockThickness(), halign="center", valign="top");
}

legArmExample();
translate([squareStockThickness() * 8, 0]) dowelExample();
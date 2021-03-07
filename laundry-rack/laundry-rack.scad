// Folding Laundy Rack

// TODO: paracord and hooks
// TODO: treat Z as "up", as "front"/"top"/etc. view settings do
// TODO: move lengths to variables
// TODO: parameterize? angles? dowel count?
// TODO: animate open/close?

// finer faceting on small cylinders
$fs = 0.1;

// input measurements
dowelDiameter = 1.3;

squareStockThickness = 1.9;
squareStockWidth = 3.8;

longDowelLength = 108;

armLength = 87.8;
legLength = 141.9;

// computed measurements
dowelRadius = dowelDiameter / 2;
shortDowelLength = longDowelLength - (squareStockThickness * 2);

// colors
longDowelColor = [0.6, 0.6, 1];
shortDowelColor = [0, 0, 1];
legColor = [0.5, 1.0, 0.5];
armColor = [0.9, 0.5, 0.8];

module dowel(length) {
    cylinder(h = length, r = dowelRadius);
}

module squareStock(length) {
    translate([0, -squareStockWidth / 2, 0])
        cube([length, squareStockWidth, squareStockThickness]);
}

module longDowel() {
    color(longDowelColor)
    dowel(longDowelLength);
}

module shortDowel() {
    color(shortDowelColor)
    dowel(shortDowelLength);
}

// subtract this from arm & leg
module dowelHole(distance) {
    translate([distance, 0, -0.1]) dowel(squareStockThickness + 0.2);
}

module leg() {
    color(legColor)
    difference() {
        squareStock(legLength);
        dowelHole(14);
        dowelHole(84);
        dowelHole(140);
    }
}

module arm() {
    color(armColor)
    difference() {
        squareStock(armLength);
        dowelHole(1.9);
        dowelHole(15.9);
        dowelHole(29.9);
        dowelHole(43.9);
        dowelHole(57.9);
        dowelHole(71.9);
        dowelHole(85.9);
    }
}

rotate([0, 0, 60]) leg();
translate([84, 0, squareStockThickness]) rotate([0, 0, 120]) leg();
translate([84, 0, longDowelLength - (squareStockThickness * 2)]) rotate([0, 0, 120]) leg();
translate([0, 0, longDowelLength - squareStockThickness]) rotate([0, 0, 60]) leg();

// bottom dowels
translate([7, 7 * sqrt(3)]) longDowel();
translate([77, 7 * sqrt(3), squareStockThickness]) shortDowel();

// middle pivot
translate([42, 42 * sqrt(3)]) longDowel();

// top pivots
translate([14, 70 * sqrt(3)]) longDowel();
translate([70, 70 * sqrt(3)]) longDowel();
translate([42, 70 * sqrt(3)]) longDowel();

// left side
translate([-43.9, 70 * sqrt(3), 0]) arm();
translate([-43.9, 70 * sqrt(3), longDowelLength - squareStockThickness]) arm();
translate([28, 70 * sqrt(3)]) longDowel();
translate([0, 70 * sqrt(3)]) longDowel();
translate([-14, 70 * sqrt(3)]) longDowel();
translate([-28, 70 * sqrt(3)]) longDowel();
translate([-42, 70 * sqrt(3)]) longDowel();

// right side
translate([40, 70 * sqrt(3), squareStockThickness]) arm();
translate([40, 70 * sqrt(3), longDowelLength - (squareStockThickness * 2)]) arm();
translate([55.9, 70 * sqrt(3), squareStockThickness]) shortDowel();
translate([83.9, 70 * sqrt(3), squareStockThickness]) shortDowel();
translate([97.9, 70 * sqrt(3), squareStockThickness]) shortDowel();
translate([111.9, 70 * sqrt(3), squareStockThickness]) shortDowel();
translate([125.9, 70 * sqrt(3), squareStockThickness]) shortDowel();
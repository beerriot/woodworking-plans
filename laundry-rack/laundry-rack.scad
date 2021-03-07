// Folding Laundy Rack

// TODO: paracord and hooks
// TODO: animate open/close?

// finer faceting on small cylinders
$fs = 0.1;

// INPUT MEASUREMENTS
dowelDiameter = 1.3;

squareStockThickness = 1.9;
squareStockWidth = 3.8;

longDowelLength = 108;

hangingHeight = 121.243;
legAngle = 60;

// Ratio of the upper leg triangle to the lower leg triangle
upperRatio = 4;
lowerRatio = 6;

// how many dowels between arm pivot points
innerDowels = 1;
// how many dowels outside arm pivot points
outerDowels = 4;

// COMPUTED MEASUREMENTS
dowelRadius = dowelDiameter / 2;
shortDowelLength = longDowelLength - (squareStockThickness * 2);

heightToLegRatio = sin(legAngle);

// hypotenuse of desired height plus half the width to hold the dowel
legLength = (hangingHeight / heightToLegRatio) + (squareStockWidth / 2);
topLegDowelDistance = legLength - squareStockWidth / 2;
middleLegDowelDistance = (legLength / (upperRatio + lowerRatio)) * lowerRatio;
bottomLegDowelDistance = legLength / (upperRatio + lowerRatio);
legShift = middleLegDowelDistance * cos(legAngle);

armPivotDowelSpan = (topLegDowelDistance - middleLegDowelDistance) * cos(legAngle);
armHangDowelSpan = armPivotDowelSpan / (innerDowels + 1);
armLength = armHangDowelSpan * (innerDowels + outerDowels + 1) + squareStockWidth;
armDowelHoles = [for (i=[0:(innerDowels + outerDowels + 1)]) (squareStockWidth / 2) + i * armHangDowelSpan];

// COLORS
longDowelColor = [0.6, 0.6, 1];
shortDowelColor = [0, 0, 1];
legColor = [0.5, 1.0, 0.5];
armColor = [0.9, 0.5, 0.8];

module dowel(length) {
    rotate([-90, 0, 0]) cylinder(h = length, r = dowelRadius);
}

module squareStock(length) {
    translate([0, 0, -squareStockWidth / 2])
        cube([length, squareStockThickness, squareStockWidth]);
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
    translate([distance, -0.1]) dowel(squareStockThickness + 0.2);
}

module leg() {
    color(legColor)
    difference() {
        squareStock(legLength);
        dowelHole(bottomLegDowelDistance);
        dowelHole(middleLegDowelDistance);
        dowelHole(topLegDowelDistance);
    }
}

module arm() {
    color(armColor)
    difference() {
        squareStock(armLength);
        for (i=armDowelHoles) dowelHole(i);
    }
}

rotate([0, -legAngle, 0]) {
    leg();
    translate([bottomLegDowelDistance, 0]) longDowel();
    translate([middleLegDowelDistance, 0]) longDowel();
    translate([0, longDowelLength - squareStockThickness]) leg();
}
translate([legShift*2, 0]) rotate([0, legAngle - 180, 0]) {
    translate([0, squareStockThickness]) leg();
    translate([0, longDowelLength - (squareStockThickness * 2)]) leg();
    translate([bottomLegDowelDistance, squareStockThickness]) shortDowel();
}

translate([legShift - squareStockThickness - (armHangDowelSpan * (len(armDowelHoles)-1)), 0, hangingHeight]) {
    arm();
    translate([0, longDowelLength - squareStockThickness]) arm();
    for (i = armDowelHoles) translate([i, 0]) longDowel();
}
translate([legShift - squareStockThickness, 0, hangingHeight]) {
    translate([0, squareStockThickness]) arm();
    translate([0, longDowelLength - squareStockThickness*2]) arm();
    translate([armDowelHoles[1], squareStockThickness]) shortDowel();
    translate([armDowelHoles[2], 0]) longDowel();
    for (i = [3:len(armDowelHoles)-1]) translate([armDowelHoles[i], squareStockThickness]) shortDowel();
}

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

hangingHeight = 121.2435;
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
middleLegDowelDistance = (topLegDowelDistance / (upperRatio + lowerRatio)) * lowerRatio;
bottomLegDowelDistance = topLegDowelDistance / (upperRatio + lowerRatio);
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

// COMPONENTS
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

module sizeLabel(distance, over=false) {
    rotate([0, 90, 0]) color("grey") {
        cylinder(0.1, r=squareStockWidth/2);
        // translated in Z, because this is unrotated, and cylinder height is in Z
        translate([0, 0, distance-0.1]) cylinder(0.1, r=squareStockThickness);
        cylinder(distance, r=0.1);
    }
    translate([distance/2, 0, (over ? 1 : -1) * squareStockWidth/4])
        rotate([90, 0, 0])
        color("grey")
        text(str(distance), halign="center", valign=(over ? "bottom" : "top"), size=squareStockWidth/2);
}

// KEY
module key() {
    module keytext(string, halign="right", valign="center", size=squareStockWidth) {
        rotate([90, 0, 0])
        color("black")
        text(string, halign=halign, valign=valign, size=size);
    }
    
    module partLabel(string) {
        translate([-squareStockWidth, 0, 0]) keytext(string);
    }

    translate([0, 0, (hangingHeight+squareStockWidth) * 1.5]) {
        translate([legLength/2, 0, -squareStockWidth*2.75])
            keytext("KEY", halign="center", valign="top", size=squareStockWidth*2);

        partLabel("LEG");
        leg();
        translate([0, 0, -squareStockWidth]) sizeLabel(legLength);
        translate([0, 0, -squareStockWidth*1.25]) sizeLabel(bottomLegDowelDistance);

        translate([0, 0, squareStockWidth]) sizeLabel(middleLegDowelDistance, over=true);
        translate([middleLegDowelDistance, 0, squareStockWidth]) sizeLabel(topLegDowelDistance-middleLegDowelDistance, over=true);
        translate([topLegDowelDistance, 0, squareStockWidth]) sizeLabel(legLength-topLegDowelDistance, over=true);
        
        translate([0, 0, squareStockWidth*4.5]){
            partLabel("ARM");
            arm();
            translate([0, 0, -squareStockWidth]) sizeLabel(armLength);
            translate([0, 0, squareStockWidth]) sizeLabel(squareStockWidth/2, over=true);
            for (i=[1:len(armDowelHoles)-1]) translate([armDowelHoles[i-1], 0, squareStockWidth]) sizeLabel(armHangDowelSpan, over=true);
            translate([armDowelHoles[len(armDowelHoles)-1], 0, squareStockWidth]) sizeLabel(squareStockWidth/2, over=true);
            
            translate([0, 0, squareStockWidth*4.5]) {
                partLabel("LONG DOWEL");
                rotate([0, 0, -90]) longDowel();
                translate([0, 0, -squareStockWidth]) sizeLabel(longDowelLength);
                
                translate([0, 0, squareStockWidth*3]) {
                    partLabel("SHORT DOWEL");
                    rotate([0, 0, -90]) shortDowel();
                    translate([0, 0, -squareStockWidth]) sizeLabel(shortDowelLength);
                }
            }
        }
    }
}
key();

// ASSEMBLY
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

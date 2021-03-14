// Folding Laundy Rack

use <../common/common.scad>
use <../common/labeling.scad>

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

paracordRadius = 0.3;

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

// distance from arm-to-arm pivot to leg-to-leg pivot
pivotVerticalSpan = heightToLegRatio*(topLegDowelDistance-middleLegDowelDistance);


armPivotDowelSpan = (topLegDowelDistance - middleLegDowelDistance) * cos(legAngle);
armHangDowelSpan = armPivotDowelSpan / (innerDowels + 1);
armLength = armHangDowelSpan * (innerDowels + outerDowels + 1) + squareStockWidth;
armDowelHoles = [for (i=[0:(innerDowels + outerDowels + 1)]) (squareStockWidth / 2) + i * armHangDowelSpan];

hookWireRadius = paracordRadius/2;
hookShaftLength = dowelDiameter * 2;

// COLORS
longDowelColor = [0.6, 0.6, 1];
shortDowelColor = [0, 0, 1];
legColor = [0.5, 1.0, 0.5];
armColor = [0.9, 0.5, 0.8];
paracordColor = [0, 0, 0];
hookColor = [0.8, 0.8, 0.8];

// COMPONENTS
module dowel(length, errs=[0,0]) {
    rotate([0, 0, 90]) roundStock(length, dowelRadius, errs);
}

module armLegStock(length, errs=[0,0,0]) {
    translate([0, 0, -squareStockWidth / 2])
    squareStock(length, squareStockThickness, squareStockWidth, errs);
}

module longDowel(includeLabels=false) {
    color(longDowelColor)
    dowel(longDowelLength);
    
    if (includeLabels) {
        translate([0, 0, -squareStockWidth]) rotate([0, 0, 90]) sizeLabel(longDowelLength);
    }
}

module shortDowel(includeLabels=false) {
    color(shortDowelColor)
    dowel(shortDowelLength);
    
    if (includeLabels) {
        translate([0, 0, -squareStockWidth]) rotate([0, 0, 90]) sizeLabel(shortDowelLength);
    }
}

// subtract this from arm & leg
module dowelHole(distance) {
    translate([distance, 0]) dowel(squareStockThickness, [2, 0]);
}

module leg(includeLabels=false) {
    color(legColor)
    difference() {
        armLegStock(legLength);
        dowelHole(bottomLegDowelDistance);
        dowelHole(middleLegDowelDistance);
        dowelHole(topLegDowelDistance);
        
        rotate([0, legAngle, 0]) translate([0,0,-squareStockWidth/2]) armLegStock(squareStockWidth, [-1, 2, 0]);
    }
    
    if (includeLabels) {
        translate([0, 0, -squareStockWidth]) sizeLabel(legLength);
        translate([0, 0, -squareStockWidth*1.25]) sizeLabel(bottomLegDowelDistance);

        translate([0, 0, squareStockWidth]) sizeLabel(middleLegDowelDistance, over=true);
        translate([middleLegDowelDistance, 0, squareStockWidth]) sizeLabel(topLegDowelDistance-middleLegDowelDistance, over=true);
        translate([topLegDowelDistance, 0, squareStockWidth]) sizeLabel(legLength-topLegDowelDistance, over=true);
    }
}

module arm(includeLabels=false) {
    color(armColor)
    difference() {
        armLegStock(armLength);
        for (i=armDowelHoles) dowelHole(i);
    }
    
    if (includeLabels) {
        translate([0, 0, -squareStockWidth]) sizeLabel(armLength);
        translate([0, 0, squareStockWidth]) sizeLabel(squareStockWidth/2, over=true);
        for (i=[1:len(armDowelHoles)-1]) translate([armDowelHoles[i-1], 0, squareStockWidth]) sizeLabel(armHangDowelSpan, over=true);
        translate([armDowelHoles[len(armDowelHoles)-1], 0, squareStockWidth]) sizeLabel(squareStockWidth/2, over=true);
    }
}

module paracordLine(length, includeLabels=false) {
    color(paracordColor) cylinder(length, r=paracordRadius);
    
    if (includeLabels) {
        rotate([0, -90, 0])  translate([0, 0, -squareStockWidth]) sizeLabel(round(pivotVerticalSpan * 1.25));
    }
}

module paracordLoop() {
    color(paracordColor) rotate([90, 0, 0]) rotate_extrude(convexity=10) translate([dowelRadius + paracordRadius, 0]) circle(paracordRadius);
}

module hook() {
    hookLevel = -(paracordRadius*1.5 + dowelDiameter*2);
    color(hookColor) {
        // top loop
        rotate([90, 0, 0]) rotate_extrude(convexity=10) translate([paracordRadius + hookWireRadius, 0]) circle(hookWireRadius);
        // straight shaft
        translate([0, 0, hookLevel]) cylinder(hookShaftLength, r=hookWireRadius);
        // curve
        translate([-(dowelRadius+hookWireRadius), 0, hookLevel]) rotate([90, 0, 0]) rotate_extrude(angle=-180, convexity=10) translate([dowelRadius + hookWireRadius, 0]) circle(hookWireRadius);
        // end
        translate([-(dowelDiameter + hookWireRadius*2), 0, hookLevel]) cylinder(dowelDiameter*0.5, r=hookWireRadius);
    }
}

module lock() {
    // hooks are asymetric, so cord has to run to the side of the dowel
    paracordAngle = atan((dowelRadius+hookWireRadius)/pivotVerticalSpan);
    // length of the unit, given the swing out of the way
    hypLength = pivotVerticalSpan / cos(paracordAngle);
        
    rotate([0, -paracordAngle, 0]) {
        paracordLoop();
        
        loopHalfHeight = dowelRadius+paracordRadius;
        hookHalfHeight = hookWireRadius*1.5 + hookShaftLength;
        lineLength = hypLength - loopHalfHeight - hookHalfHeight;
        translate([0, 0, -(loopHalfHeight+lineLength)]) paracordLine(lineLength);
        
        translate([0, 0, -(loopHalfHeight+lineLength)]) hook();
        
    }
}

// KEY
module partsKey() {
    translate([0, 0, (hangingHeight+squareStockWidth) * 1.5]) {
        translate([legLength/2, 0])
        rotate([90, 0, 0])
        color("black")
        text("KEY", halign="center", valign="top", size=squareStockWidth*2);
        
        space = squareStockWidth + sizeLabelHeight();
        
        key([keyChildInfo("LEG", 4, space, space*1.5),
             keyChildInfo("ARM", 4, space, space),
             keyChildInfo("LONG DOWEL", 5 + innerDowels + outerDowels, space/2, space),
             keyChildInfo("SHORT DOWEL", 1 + innerDowels + outerDowels, space/2, space),
             keyChildInfo("PARACORD", 2, space/2, space),
             keyChildInfo("HOOK", 2, space/2, space)]) {
            leg(includeLabels=true);
            arm(includeLabels=true);
            rotate([0, 0, -90]) longDowel(includeLabels=true);
            rotate([0, 0, -90]) shortDowel(includeLabels=true);
            rotate([0, 90, 0]) paracordLine(round(pivotVerticalSpan * 1.25), includeLabels=true);
            rotate([0, -90, 0]) hook();
         }
    }    
}
partsKey();

// ASSEMBLY
rotate([0, -legAngle, 0]) {
    leg();
    translate([bottomLegDowelDistance, 0]) longDowel();
    translate([middleLegDowelDistance, 0]) longDowel();
    translate([0, longDowelLength - squareStockThickness]) leg();
}
    
translate([legShift*2, 0]) rotate([0, legAngle, 0]) {
    translate([0, squareStockThickness]) mirror([1, 0, 0]) leg();
    translate([0, shortDowelLength]) mirror([1, 0, 0]) leg();
    translate([-bottomLegDowelDistance, squareStockThickness]) shortDowel();
}

endOfLeftArm = legShift - squareStockThickness - (armHangDowelSpan * (len(armDowelHoles)-1));
translate([endOfLeftArm, 0, hangingHeight]) {
    arm();
    translate([0, longDowelLength - squareStockThickness]) arm();
    for (i = armDowelHoles) translate([i, 0]) longDowel();
        
    translate([armDowelHoles[len(armDowelHoles)-1], 0]) {
        translate([0, squareStockThickness*2+paracordRadius]) lock();
        translate([0, longDowelLength - squareStockThickness*2 - paracordRadius]) lock();
    }
}
translate([legShift - squareStockThickness, 0, hangingHeight]) {
    translate([0, squareStockThickness]) arm();
    translate([0, longDowelLength - squareStockThickness*2]) arm();
    translate([armDowelHoles[1], squareStockThickness]) shortDowel();
    translate([armDowelHoles[2], 0]) longDowel();
    for (i = [3:len(armDowelHoles)-1]) translate([armDowelHoles[i], squareStockThickness]) shortDowel();
}

// ASSEMBLED SIZES
translate([endOfLeftArm, 0, 0]) {
    // front sizes
    translate([-squareStockWidth*1.5, 0]) rotate([0, -90, 0]) sizeLabel(hangingHeight, over=true);
    translate([0, 0, hangingHeight + squareStockWidth*1.5]) sizeLabel(armLength*2 - squareStockWidth, over=true);
    
    // top sizes
    translate([0, longDowelLength + squareStockWidth*1.5, hangingHeight + squareStockWidth*1.5]) rotate([-90, 0, 0]) sizeLabel(armLength*2 - squareStockWidth, over=true);
    translate([-squareStockWidth*1.5, 0, hangingHeight + squareStockWidth*1.5]) rotate([-90, 0, 90]) sizeLabel(longDowelLength, over=true);
    translate([armLength*2 + squareStockWidth*0.5, squareStockThickness+shortDowelLength, hangingHeight + squareStockWidth*1.5]) rotate([-90, 0, -90]) sizeLabel(shortDowelLength, over=true);
}


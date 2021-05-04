// Folding Laundy Rack

use <../common/common.scad>

// TODO: animate open/close?

// finer faceting on small cylinders
$fs = 0.1;

// INPUT MEASUREMENTS
include <params.scad>

// COMPUTED MEASUREMENTS
function dowelRadius() = dowelDiameter / 2;
function shortDowelLength() = longDowelLength - (squareStockThickness * 2);

function dowelInset() = squareStockWidth / 2;
function doubleSquareStockThickness() = squareStockThickness * 2;

function heightToLegRatio() = sin(legAngle);

// Complement is not used in the model, but is used in the diagrams and
// instructions.
function legAngleComplement() = 90 - legAngle;

function legLength() =
    // hypotenuse of desired height plus half the width to hold the dowel
    (hangingHeight / heightToLegRatio()) + (squareStockWidth / 2);

// Positions of each dowel hole in the leg, relative to the floor end
function topLegDowelDistance() = legLength() - squareStockWidth / 2;
function middleLegDowelDistance() =
    (topLegDowelDistance() / (upperRatio + lowerRatio)) * lowerRatio;
function bottomLegDowelDistance() =
    topLegDowelDistance() / (upperRatio + lowerRatio);

// How far across the floor the middle pivot is, when the leg is standing
function legShift() = middleLegDowelDistance() * cos(legAngle);

// distance from arm-to-arm pivot to leg-to-leg pivot
function pivotVerticalSpan() =
    heightToLegRatio() * (topLegDowelDistance() - middleLegDowelDistance());

// Distance between the centers of the two pivot dowels in each arm
function armPivotDowelSpan() =
    (topLegDowelDistance() - middleLegDowelDistance()) * cos(legAngle);

// Distance between centers of each dowel in the arms
function armHangDowelSpan() = armPivotDowelSpan() / (innerDowels + 1);

// Total length of the arm component
function armLength() =
    // distances between dowel centers, plus the overhang at each end
    armHangDowelSpan() * (innerDowels + outerDowels + 1) + squareStockWidth;

// Position of each whole in each arm, relative to the end.
// They're symmetrical, so which end doesn't matter.
function armDowelHoles() =
    [for (i = [0 : (innerDowels + outerDowels + 1)])
            (squareStockWidth / 2) + i * armHangDowelSpan()];

// Defining this may seem extraneous, but it makes the value available for
// HTML insertion.
function armDowelHoleCount() = len(armDowelHoles());

// How far across the floor the end of the left arm is from the base
// of the left leg. This is a negative number to make it easy to shift
// the arm assembly into position.
function endOfLeftArm() =
    legShift() - squareStockThickness -
    (armHangDowelSpan() * (len(armDowelHoles()) - 1));

// 5: the four pivots, plus the foot of the wide legs
function longDowelCount() = 5 + innerDowels + outerDowels;
function nonPivotLongDowelCount() = longDowelCount() - 4;

// Counted for just one arm.
function nonPivotHangingDowelCount() = innerDowels + outerDowels;

// 1: the foot of the narrow legs
function shortDowelCount() = 1 + innerDowels + outerDowels;

function paracordRadius() = paracordDiameter / 2;
function hookWireRadius() = paracordRadius() / 2;
function hookShaftLength() = dowelDiameter * 2;

// COLORS

module longDowelColor() {
    color(longDowelColor) children();
}
module shortDowelColor() {
    color(shortDowelColor) children();
}
module legColor() {
    color(legColor) children();
}
module armColor() {
    color(armColor) children();
}
module paracordColor() {
    color(paracordColor) children();
}
module hookColor() {
    color(hookColor) children();
}

// COMPONENTS

module dowel(length, errs=[0,0]) {
    rotate([0, 0, 90]) roundStock(length, dowelRadius(), errs);
}

module armLegStock(length, errs=[0,0,0]) {
    translate([0, 0, -squareStockWidth / 2])
        squareStock([length, squareStockThickness, squareStockWidth], errs);
}

module longDowel() {
    longDowelColor() dowel(longDowelLength);
}
module shortDowel() {
    shortDowelColor() dowel(shortDowelLength());
}

// subtract this from arm & leg
module dowelHole(distance) {
    translate([distance, 0]) dowel(squareStockThickness, [2, 0]);
}

module legBlank() {
    legColor() armLegStock(legLength());
}

module leg() {
    difference() {
        legBlank();
        dowelHole(bottomLegDowelDistance());
        dowelHole(middleLegDowelDistance());
        dowelHole(topLegDowelDistance());

        rotate([0, legAngle, 0]) translate([0, 0, -squareStockWidth / 2])
            armLegStock(squareStockWidth, [-1, 2, 0]);
    }
}

module armBlank() {
    armColor() armLegStock(armLength());
}

module arm() {
    armColor() difference() {
        armBlank();
        for (i = armDowelHoles()) dowelHole(i);
    }
}

module paracordLine(length) {
     paracordColor() cylinder(length, r=paracordRadius());
}

module paracordLoop() {
    paracordColor()
        rotate([90, 0, 0])
        rotate_extrude(convexity=10)
        translate([dowelRadius() + paracordRadius(), 0])
        circle(paracordRadius());
}

module hook() {
    hookLevel = -(paracordRadius() * 1.5 + dowelDiameter * 2);
    hookColor() {
        // top loop
        rotate([90, 0, 0]) rotate_extrude(convexity=10)
            translate([paracordRadius() + hookWireRadius(), 0])
            circle(hookWireRadius());
        // straight shaft
        translate([0, 0, hookLevel])
            cylinder(hookShaftLength(), r=hookWireRadius());
        // curve
        translate([-(dowelRadius() + hookWireRadius()), 0, hookLevel])
            rotate([90, 0, 0]) rotate_extrude(angle=-180, convexity=10)
            translate([dowelRadius() + hookWireRadius(), 0])
            circle(hookWireRadius());
        // end
        translate([-(dowelDiameter + hookWireRadius() * 2), 0, hookLevel])
            cylinder(dowelDiameter * 0.5, r=hookWireRadius());
    }
}

module lock() {
    // hooks are asymetric, so cord has to run to the side of the dowel
    paracordAngle =
        atan((dowelRadius() + hookWireRadius())/pivotVerticalSpan());

    // length of the unit, given the swing out of the way
    hypLength = pivotVerticalSpan() / cos(paracordAngle);

    rotate([0, -paracordAngle, 0]) {
        paracordLoop();

        loopHalfHeight = dowelRadius() + paracordRadius();
        hookHalfHeight = hookWireRadius() * 1.5 + hookShaftLength();
        lineLength = hypLength - loopHalfHeight - hookHalfHeight;
        translate([0, 0, -(loopHalfHeight + lineLength)])
            paracordLine(lineLength);

        translate([0, 0, -(loopHalfHeight + lineLength)]) hook();
    }
}

// ASSEMBLY
module narrowArms() {
    translate([0, squareStockThickness]) arm();
    translate([0, longDowelLength - squareStockThickness * 2]) arm();
    translate([armDowelHoles()[0], 0]) longDowel();
    for (i = [0 : innerDowels - 1])
        translate([armDowelHoles()[1 + i], squareStockThickness])
            shortDowel();
    translate([armDowelHoles()[1 + innerDowels], 0]) longDowel();
    for (i = [0 : outerDowels - 1])
        translate([armDowelHoles()[2 + innerDowels + i],
                   squareStockThickness])
            shortDowel();
}

module wideArms(includeTop=true, includePivot=true) {
    if (includeTop) arm();
    translate([0, longDowelLength - squareStockThickness]) arm();
    for (i = [0 : len(armDowelHoles()) - 2])
        if (i != outerDowels || includePivot)
            translate([armDowelHoles()[i], 0])
                longDowel();
}

module legs(includeInnerTop=true, includeOuterTop=true) {
    rotate([0, -legAngle, 0]) {
        if (includeOuterTop) leg();
        translate([bottomLegDowelDistance(), 0]) longDowel();
        translate([middleLegDowelDistance(), 0]) longDowel();
        translate([0, longDowelLength - squareStockThickness]) leg();
    }

    translate([legShift() * 2, 0]) rotate([0, legAngle, 0]) {
        if (includeInnerTop)
            translate([0, squareStockThickness])
                mirror([1, 0, 0])
                leg();
        translate([0, shortDowelLength()]) mirror([1, 0, 0]) leg();
        translate([-bottomLegDowelDistance(), squareStockThickness])
            shortDowel();
    }
}

module assembly() {
    legs();

    translate([endOfLeftArm(), 0, hangingHeight]) {
        wideArms();

        translate([armDowelHoles()[len(armDowelHoles())-1], 0]) {
            translate([0, squareStockThickness * 2 + paracordRadius()])
                lock();
            translate([0,
                       longDowelLength - squareStockThickness * 2 -
                       paracordRadius()])
                lock();
        }
    }
    translate([legShift() - dowelInset(), 0, hangingHeight])
        narrowArms();
}

assembly();

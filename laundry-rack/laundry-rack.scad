// Folding Laundy Rack

use <../common/common.scad>
use <../common/labeling.scad>

// TODO: animate open/close?

// finer faceting on small cylinders
$fs = 0.1;

// INPUT MEASUREMENTS
function dowelDiameter() = 1.3;

function squareStockThickness() = 1.9;
function squareStockWidth() = 3.8;

function longDowelLength() = 108;

function hangingHeight() = 121.2435;
function legAngle() = 60;

// Ratio of the upper leg triangle to the lower leg triangle
function upperRatio() = 4;
function lowerRatio() = 6;

// how many dowels between arm pivot points
function innerDowels() = 1;
// how many dowels outside arm pivot points
function outerDowels() = 4;

function paracordRadius() = 0.3;

// COMPUTED MEASUREMENTS
function dowelRadius() = dowelDiameter() / 2;
function shortDowelLength() = longDowelLength() - (squareStockThickness() * 2);

function dowelInset() = squareStockWidth() / 2;
function doubleSquareStockThickness() = squareStockThickness() * 2;

function heightToLegRatio() = sin(legAngle());

// Complement is not used in the model, but is used in the diagrams and
// instructions.
function legAngleComplement() = 90 - legAngle();

function legLength() =
    // hypotenuse of desired height plus half the width to hold the dowel
    (hangingHeight() / heightToLegRatio()) + (squareStockWidth() / 2);

// Positions of each dowel hole in the leg, relative to the floor end    
function topLegDowelDistance() = legLength() - squareStockWidth() / 2;
function middleLegDowelDistance() =
    (topLegDowelDistance() / (upperRatio() + lowerRatio())) * lowerRatio();
function bottomLegDowelDistance() =
    topLegDowelDistance() / (upperRatio() + lowerRatio());

// How far across the floor the middle pivot is, when the leg is standing
function legShift() = middleLegDowelDistance() * cos(legAngle());
function endOfLeftArm() =
    legShift() - squareStockThickness() -
        (armHangDowelSpan() * (len(armDowelHoles()) - 1));

// distance from arm-to-arm pivot to leg-to-leg pivot
function pivotVerticalSpan() =
    heightToLegRatio() * (topLegDowelDistance() - middleLegDowelDistance());

// Distance between the centers of the two pivot dowels in each arm
function armPivotDowelSpan() =
    (topLegDowelDistance() - middleLegDowelDistance()) * cos(legAngle());

// Distance between centers of each dowel in the arms
function armHangDowelSpan() = armPivotDowelSpan() / (innerDowels() + 1);

// Total length of the arm component
function armLength() =
    // distances between dowel centers, plus the overhang at each end
    armHangDowelSpan() * (innerDowels() + outerDowels() + 1)
        + squareStockWidth();
        
// Position of each whole in each arm, relative to the end.
// They're symmetrical, so which end doesn't matter.
function armDowelHoles() =
    [for (i = [0 : (innerDowels() + outerDowels() + 1)])
        (squareStockWidth() / 2) + i * armHangDowelSpan()];

// Defining this may seem extraneous, but it makes the value available for
// HTML insertion.
function armDowelHoleCount() = len(armDowelHoles());

// 5: the four pivots, plus the foot of the wide legs
function longDowelCount() = 5 + innerDowels() + outerDowels();
function nonPivotLongDowelCount() = longDowelCount() - 4;
function nonPivotHangingDowelCount() = innerDowels() + outerDowels();
    
// 1: the foot of the narrow legs
function shortDowelCount() = 1 + innerDowels() + outerDowels();

function hookWireRadius() = paracordRadius() / 2;
function hookShaftLength() = dowelDiameter() * 2;

// COLORS
module longDowelColor() color([0.6, 0.6, 1]) children();
module shortDowelColor() color([0, 0, 1]) children();
module legColor() color([0.5, 1.0, 0.5]) children();
module armColor() color([0.9, 0.5, 0.8]) children();
module paracordColor() color([0, 0, 0]) children();
module hookColor() color([0.8, 0.8, 0.8]) children();

// COMPONENTS
module dowel(length, errs=[0,0]) {
    rotate([0, 0, 90]) roundStock(length, dowelRadius(), errs);
}

module armLegStock(length, errs=[0,0,0]) {
    translate([0, 0, -squareStockWidth() / 2])
    squareStock(length, squareStockThickness(), squareStockWidth(), errs);
}

module longDowel(includeLabels=false) {
    module part() longDowelColor() dowel(longDowelLength());
    
    if (includeLabels) {
        thirdAngle(longDowelLength(), dowelRadius() * 2, dowelRadius() * 2) {
            translate([0, 0, dowelRadius()]) rotate([0, 0, -90]) part();

            sizeLabel(longDowelLength());
            
            taRightSide(longDowelLength())
                sizeLabel(dowelRadius() * 2, rotation=-90);
        }
    } else {
        part();
    }
}

module shortDowel(includeLabels=false) {
    module part() shortDowelColor() dowel(shortDowelLength());
    
    if (includeLabels) {
        thirdAngle(shortDowelLength(), dowelRadius() * 2, dowelRadius() * 2) {
            translate([0, 0, dowelRadius()]) rotate([0, 0, -90]) part();

            sizeLabel(shortDowelLength());
            
            taRightSide(shortDowelLength())
                sizeLabel(dowelRadius() * 2, rotation=-90);
        }
    } else {
        part();
    }
}

// subtract this from arm & leg
module dowelHole(distance)
    translate([distance, 0]) dowel(squareStockThickness(), [2, 0]);

module legBlank() {
    legColor() armLegStock(legLength());
}

module leg(includeLabels=false) {
    module part() difference() {
        legBlank();
        dowelHole(bottomLegDowelDistance());
        dowelHole(middleLegDowelDistance());
        dowelHole(topLegDowelDistance());
        
        rotate([0, legAngle(), 0]) translate([0, 0, -squareStockWidth() / 2])
            armLegStock(squareStockWidth(), [-1, 2, 0]);
    }
    
    if (includeLabels) {
        thirdAngle(legLength(), squareStockThickness(), squareStockWidth(),
                   frontLabels=[1,0,1]) {
            translate([0, 0, squareStockWidth() / 2]) part();
            
            union() {
                sizeLabel(legLength());
                translate([0, 0, -squareStockWidth() * 0.25])
                    sizeLabel(bottomLegDowelDistance());

                translate([0, 0, squareStockWidth()])
                    sizeLabel(middleLegDowelDistance(), over=true);
                translate([middleLegDowelDistance(), 0, squareStockWidth()])
                    sizeLabel(topLegDowelDistance() - middleLegDowelDistance(),
                              over=true);
                translate([topLegDowelDistance(), 0, squareStockWidth()])
                    sizeLabel(legLength() - topLegDowelDistance(), over=true);
            }
 
            taRightSide(legLength()) {
                sizeLabel(squareStockThickness());
                translate([squareStockThickness(), 0])
                    sizeLabel(squareStockWidth(), rotation=-90);
            }
       }
    } else {
        part();
    }
}

module armBlank() {
    armColor() armLegStock(armLength());
}

module arm(includeLabels=false) {
    module part() armColor() difference() {
        armBlank();
        for (i = armDowelHoles()) dowelHole(i);
    }
    
    if (includeLabels) {
        thirdAngle(armLength(), squareStockThickness(), squareStockWidth(),
                   frontLabels=[1,0,1]) {
            translate([0, 0, squareStockWidth() / 2]) part();

            union() {
                sizeLabel(armLength());
                translate([0, 0, squareStockWidth()])
                    sizeLabel(squareStockWidth() / 2, over=true);
                for (i = [1 : len(armDowelHoles()) - 1])
                    translate([armDowelHoles()[i - 1],
                               0,
                               squareStockWidth()])
                        sizeLabel(armHangDowelSpan(), over=true);
                translate([armDowelHoles()[len(armDowelHoles()) - 1],
                           0,
                           squareStockWidth()])
                    sizeLabel(squareStockWidth() / 2, over=true);
            }
            
            taRightSide(armLength()) {
                sizeLabel(squareStockThickness());
                translate([squareStockThickness(), 0])
                    sizeLabel(squareStockWidth(), rotation=-90);
            }
        }
    } else {
        part();
    }
}

module paracordLine(length, includeLabels=false) {
    paracordColor() cylinder(length, r=paracordRadius());
    
    if (includeLabels) {
        rotate([0, -90, 0])  translate([0, 0, -paracordRadius()])
            sizeLabel(round(pivotVerticalSpan() * 1.25));
    }
}

module paracordLoop() {
    paracordColor() rotate([90, 0, 0]) rotate_extrude(convexity=10)
        translate([dowelRadius() + paracordRadius(), 0])
        circle(paracordRadius());
}

module hook() {
    hookLevel = -(paracordRadius() * 1.5 + dowelDiameter() * 2);
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
        translate([-(dowelDiameter() + hookWireRadius() * 2), 0, hookLevel])
            cylinder(dowelDiameter() * 0.5, r=hookWireRadius());
    }
}

module lock() {
    // hooks are asymetric, so cord has to run to the side of the dowel
    paracordAngle = atan((dowelRadius() + hookWireRadius())/pivotVerticalSpan());
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

// KEY
module partsKey() {
        
    squareSpaceAbove = (squareStockWidth() + sizeLabelHeight()) * 1.35;
    spaceBelow = sizeLabelHeight() * 1.25;
    dowelSpaceAbove = max(dowelDiameter(), sizeLabelHeight()) * 1.25;
    
    key([keyChildInfo("LEG", 4, squareSpaceAbove, spaceBelow),
         keyChildInfo("ARM", 4, squareSpaceAbove, spaceBelow),
         keyChildInfo("LONG DOWEL", 5 + innerDowels() + outerDowels(),
                      dowelSpaceAbove, spaceBelow),
         keyChildInfo("SHORT DOWEL", 1 + innerDowels() + outerDowels(),
                      dowelSpaceAbove, spaceBelow),
         keyChildInfo("PARACORD", 2, dowelSpaceAbove, spaceBelow),
         keyChildInfo("HOOK", 2, dowelSpaceAbove, spaceBelow)]) {
        leg(includeLabels=true);
        arm(includeLabels=true);
        longDowel(includeLabels=true);
        shortDowel(includeLabels=true);
        rotate([0, 90, 0])
            paracordLine(round(pivotVerticalSpan() * 1.25), includeLabels=true);
        rotate([0, -90, 0]) hook();
     }
}

translate([0, 0, (hangingHeight() + squareStockWidth()) * 1.5]) {
    translate([legLength() / 2, 0])
    rotate([90, 0, 0])
    color("black")
    text("KEY", halign="center", valign="top", size=squareStockWidth() * 2);

    partsKey();
}

// ASSEMBLY
module narrowArms() {
    translate([0, squareStockThickness()]) arm();
    translate([0, longDowelLength() - squareStockThickness() * 2]) arm();
    translate([armDowelHoles()[0], 0]) longDowel();
    for (i = [0 : innerDowels() - 1])
        translate([armDowelHoles()[1 + i], squareStockThickness()]) shortDowel();
    translate([armDowelHoles()[1 + innerDowels()], 0]) longDowel();
    for (i = [0 : outerDowels() - 1])
        translate([armDowelHoles()[2 + innerDowels() + i],
                   squareStockThickness()])
            shortDowel();
}

module wideArms(includeTop=true, includePivot=true) {
    if (includeTop) arm();
    translate([0, longDowelLength() - squareStockThickness()]) arm();
    for (i = [0 : len(armDowelHoles()) - 2])
       if (i != outerDowels() || includePivot)
           translate([armDowelHoles()[i], 0]) longDowel();
}

module legs(includeInnerTop=true, includeOuterTop=true) {
    rotate([0, -legAngle(), 0]) {
        if (includeOuterTop) leg();
        translate([bottomLegDowelDistance(), 0]) longDowel();
        translate([middleLegDowelDistance(), 0]) longDowel();
        translate([0, longDowelLength() - squareStockThickness()]) leg();
    }
        
    translate([legShift() * 2, 0]) rotate([0, legAngle(), 0]) {
        if (includeInnerTop) translate([0, squareStockThickness()])
            mirror([1, 0, 0]) leg();
        translate([0, shortDowelLength()]) mirror([1, 0, 0]) leg();
        translate([-bottomLegDowelDistance(), squareStockThickness()])
            shortDowel();
    }
}

module assembly(includeLabels=false) {
    module whole() {
        legs();

        translate([endOfLeftArm(), 0, hangingHeight()]) {
            wideArms();
                    
            translate([armDowelHoles()[len(armDowelHoles())-1], 0]) {
                translate([0, squareStockThickness() * 2 + paracordRadius()])
                    lock();
                translate([0,
                           longDowelLength() - squareStockThickness() * 2 -
                               paracordRadius()])
                lock();
            }
        }
        translate([legShift() - dowelInset(), 0, hangingHeight()])
            narrowArms();
    }
    
    if (includeLabels) {
        thirdAngle(legShift() + armLength(),
                   longDowelLength() * 1.25,
                   hangingHeight(),
                   frontLabels=[1, 1, 1], topLabels=[0,1,1]) {
            whole();
            
            union() {
                // top length
                translate([endOfLeftArm(),
                           0,
                           hangingHeight() + squareStockWidth() / 2])
                    sizeLabel(armLength() * 2 - squareStockWidth(), over=true);

                // hanging height
                translate([endOfLeftArm(), 0])
                    sizeLabel(hangingHeight(), rotation=-90, over=true);

                // paracord length
                translate([legShift(),
                           0,
                           hangingHeight() - pivotVerticalSpan()])
                    sizeLabel(pivotVerticalSpan(), rotation=-90);
                
                // bottom length
                sizeLabel(legShift() * 2);
            }
            
            // total depth
            taRightSide(legShift() + armLength())
                translate([0, 0, hangingHeight() + squareStockWidth() / 2])
                sizeLabel(longDowelLength(), over=true);

            
            taTopSide(hangingHeight() + squareStockWidth() / 2) {
                // long inner dowel length
                translate([endOfLeftArm(), 0, squareStockThickness()])
                    sizeLabel(longDowelLength() - squareStockThickness() * 2,
                              over=true, rotation=-90);
                
                // short inner dowel length
                translate([legShift() + armLength() - squareStockWidth() / 2,
                           0,
                           squareStockThickness() * 2])
                    sizeLabel(shortDowelLength() - squareStockThickness() * 2,
                              rotation=-90);
            }
        }
    } else {
        whole();
    }
}
assembly();

translate([(legShift() + armLength()) * 2, 0]) assembly(includeLabels=true);

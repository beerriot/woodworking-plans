// Components Key
//cmdline: --projection=o --imgsize=2048,1024
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 40.51, -137.37, 40.81 ];
$vpf=22.50;
$vpd=285.72;

module longDowelKey() 
    thirdAngle([longDowelLength, dowelRadius() * 2, dowelRadius() * 2]) {
        translate([0, 0, dowelRadius()]) rotate([0, 0, -90]) longDowel();

        sizeLabel(longDowelLength);
        
        taRightSide(longDowelLength)
            sizeLabel(dowelRadius() * 2, rotation=-90);
    }
function longDowelKeySize() =
    thirdAngleSize([longDowelLength, dowelRadius() * 2, dowelRadius() * 2]);

module shortDowelKey()
    thirdAngle([shortDowelLength(), dowelRadius() * 2, dowelRadius() * 2]) {
        translate([0, 0, dowelRadius()]) rotate([0, 0, -90]) shortDowel();

        sizeLabel(shortDowelLength());
        
        taRightSide(shortDowelLength())
            sizeLabel(dowelRadius() * 2, rotation=-90);
    }
function shortDowelKeySize() =
    thirdAngleSize([shortDowelLength(), dowelRadius() * 2, dowelRadius() * 2]);

module legKey()
    thirdAngle([legLength(), squareStockThickness, squareStockWidth],
                frontLabels=[1,0,1]) {
        translate([0, 0, squareStockWidth / 2]) leg();
        
        union() {
            sizeLabel(legLength());
            translate([0, 0, -squareStockWidth * 0.25])
                sizeLabel(bottomLegDowelDistance());

            translate([0, 0, squareStockWidth])
                sizeLabel(middleLegDowelDistance(), over=true);
            translate([middleLegDowelDistance(), 0, squareStockWidth])
                sizeLabel(topLegDowelDistance() - middleLegDowelDistance(),
                          over=true);
            translate([topLegDowelDistance(), 0, squareStockWidth])
                sizeLabel(legLength() - topLegDowelDistance(), over=true);
        }

        taRightSide(legLength()) {
            sizeLabel(squareStockThickness);
            translate([squareStockThickness, 0])
                sizeLabel(squareStockWidth, rotation=-90);
        }
    }
function legKeySize() =
    thirdAngleSize([legLength(), squareStockThickness, squareStockWidth],
                    frontLabels=[1,0,1], topLabels=undef);

module armKey()
    thirdAngle([armLength(), squareStockThickness, squareStockWidth],
               frontLabels=[1,0,1]) {
        translate([0, 0, squareStockWidth / 2]) arm();

        union() {
            sizeLabel(armLength());
            translate([0, 0, squareStockWidth])
                sizeLabel(squareStockWidth / 2, over=true);
            for (i = [1 : len(armDowelHoles()) - 1])
                translate([armDowelHoles()[i - 1],
                           0,
                           squareStockWidth])
                    sizeLabel(armHangDowelSpan(), over=true);
            translate([armDowelHoles()[len(armDowelHoles()) - 1],
                       0,
                       squareStockWidth])
                sizeLabel(squareStockWidth / 2, over=true);
        }
        
        taRightSide(armLength()) {
            sizeLabel(squareStockThickness);
            translate([squareStockThickness, 0])
                sizeLabel(squareStockWidth, rotation=-90);
        }
    }
function armKeySize() =
    thirdAngleSize([armLength(), squareStockThickness, squareStockWidth],
                   frontLabels=[1,0,1], topLabels=undef);

function paracordKeyLength() = round(pivotVerticalSpan() * 1.25);
module paracordKey()
    thirdAngle([paracordKeyLength(), paracordDiameter, paracordDiameter],
               frontLabels=[0,0,1]) {
    translate([0, 0, paracordRadius()])
        rotate([0, 90, 0])
        paracordLine(paracordKeyLength());
                   
        sizeLabel(round(pivotVerticalSpan() * 1.25));
    }
function paracordKeySize() = 
    thirdAngleSize([paracordKeyLength(), paracordDiameter, paracordDiameter],
                   frontLabels=[0,0,1], rightLabels=undef, topLabels=undef);
    
// KEY
module partsKey()
    key([keyChildInfo("LEG", 4, legKeySize()),
         keyChildInfo("ARM", 4, armKeySize()),
         keyChildInfo("LONG DOWEL", longDowelCount(), longDowelKeySize()),
         keyChildInfo("SHORT DOWEL", shortDowelCount(), shortDowelKeySize()),
         keyChildInfo("PARACORD", 2, paracordKeySize()),
         keyChildInfo("HOOK", 2, [0, 0, dowelDiameter*3])]) {
        legKey();
        armKey();
        longDowelKey();
        shortDowelKey();
        paracordKey();
        translate([paracordRadius(), 0, dowelDiameter*2])
             rotate([0, -90, 0]) hook();
     }

partsKey();

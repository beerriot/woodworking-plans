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
    third_angle([longDowelLength, dowelRadius() * 2, dowelRadius() * 2]) {
        translate([0, 0, dowelRadius()]) rotate([0, 0, -90]) longDowel();

        size_label(longDowelLength);

        ta_right_side(longDowelLength)
            size_label(dowelRadius() * 2, rotation=-90);
    }
function longDowelKeySize() =
    third_angle_size([longDowelLength, dowelRadius() * 2, dowelRadius() * 2]);

module shortDowelKey()
    third_angle([shortDowelLength(), dowelRadius() * 2, dowelRadius() * 2]) {
        translate([0, 0, dowelRadius()]) rotate([0, 0, -90]) shortDowel();

        size_label(shortDowelLength());

        ta_right_side(shortDowelLength())
            size_label(dowelRadius() * 2, rotation=-90);
    }
function shortDowelKeySize() =
    third_angle_size([shortDowelLength(),
                      dowelRadius() * 2,
                      dowelRadius() * 2]);

module legKey()
    third_angle([legLength(), squareStockThickness, squareStockWidth],
                front_labels=[1,0,1]) {
        translate([0, 0, squareStockWidth / 2]) leg();

        union() {
            size_label(legLength());
            translate([0, 0, -squareStockWidth * 0.25])
                size_label(bottomLegDowelDistance());

            translate([0, 0, squareStockWidth])
                size_label(middleLegDowelDistance(), over=true);
            translate([middleLegDowelDistance(), 0, squareStockWidth])
                size_label(topLegDowelDistance() - middleLegDowelDistance(),
                          over=true);
            translate([topLegDowelDistance(), 0, squareStockWidth])
                size_label(legLength() - topLegDowelDistance(), over=true);
        }

        ta_right_side(legLength()) {
            size_label(squareStockThickness);
            translate([squareStockThickness, 0])
                size_label(squareStockWidth, rotation=-90);
        }
    }
function legKeySize() =
    third_angle_size([legLength(), squareStockThickness, squareStockWidth],
                     front_labels=[1,0,1], top_labels=undef);

module armKey()
    third_angle([armLength(), squareStockThickness, squareStockWidth],
                front_labels=[1,0,1]) {
        translate([0, 0, squareStockWidth / 2]) arm();

        union() {
            size_label(armLength());
            translate([0, 0, squareStockWidth])
                size_label(squareStockWidth / 2, over=true);
            for (i = [1 : len(armDowelHoles()) - 1])
                translate([armDowelHoles()[i - 1],
                           0,
                           squareStockWidth])
                    size_label(armHangDowelSpan(), over=true);
            translate([armDowelHoles()[len(armDowelHoles()) - 1],
                       0,
                       squareStockWidth])
                size_label(squareStockWidth / 2, over=true);
        }

        ta_right_side(armLength()) {
            size_label(squareStockThickness);
            translate([squareStockThickness, 0])
                size_label(squareStockWidth, rotation=-90);
        }
    }
function armKeySize() =
    third_angle_size([armLength(), squareStockThickness, squareStockWidth],
                     front_labels=[1,0,1], top_labels=undef);

function paracordKeyLength() = round(pivotVerticalSpan() * 1.25);
module paracordKey()
    third_angle([paracordKeyLength(), paracordDiameter, paracordDiameter],
               front_labels=[0,0,1]) {
    translate([0, 0, paracordRadius()])
        rotate([0, 90, 0])
        paracordLine(paracordKeyLength());

        size_label(round(pivotVerticalSpan() * 1.25));
    }
function paracordKeySize() =
    third_angle_size([paracordKeyLength(), paracordDiameter, paracordDiameter],
                     front_labels=[0,0,1],
                     right_labels=undef,
                     top_labels=undef);

// KEY
module partsKey()
    key([["LEG", 4, legKeySize()],
         ["ARM", 4, armKeySize()],
         ["LONG DOWEL", longDowelCount(), longDowelKeySize()],
         ["SHORT DOWEL", shortDowelCount(), shortDowelKeySize()],
         ["PARACORD", 2, paracordKeySize()],
         ["HOOK", 2, [0, 0, dowelDiameter*3]]]) {
        legKey();
        armKey();
        longDowelKey();
        shortDowelKey();
        paracordKey();
        translate([paracordRadius(), 0, dowelDiameter*2])
             rotate([0, -90, 0]) hook();
     }

partsKey();

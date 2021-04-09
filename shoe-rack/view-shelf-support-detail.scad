// The lap joint assembly
//cmdline: --projection=o --imgsize=1200,600
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 22, 4.44, 8.45 ];
$vpf=22.50;
$vpd=145.77;

$fa=1;
$fs=0.1;

spaceBetweenParts = endStockWidth * 2;
function combinedWidthOf(i) =
    (i < 0) ? 0 : shelfDepth(uniqueShelfAngles()[i][0]) + spaceBetweenParts;
function centerOf(i) = shelfDepth(uniqueShelfAngles()[i][0]) / 2 +
    combinedWidthOf(i-1);

endSize = thirdAngleSize([shelfDepth(maxShelfAngle()),
                          endStockThickness,
                          endStockWidth],
                         frontLabels=[1,0,1],
                         rightLabels=undef,
                         topLabels=undef);
centerSize = thirdAngleSize([shelfDepth(maxShelfAngle()),
                             slatStockWidth,
                             slatStockThickness],
                            frontLabels=[0,0,1],
                            rightLabels=undef,
                            topLabels=undef);

key([keyChildInfo("SHELF CENTER", len(shelfHeightsAndAngles), centerSize),
     keyChildInfo("SHELF SUPPORT", len(shelfHeightsAndAngles) * 2, endSize)]) {
    for (i = [0 : len(uniqueShelfAngles())-1]) {
        shelfAngle = uniqueShelfAngles()[i];
        translate([combinedWidthOf(i-1), 0, 0]) {
            thirdAngle(centerSize) {
                union() {
                    translate([0, 0, slatStockThickness / 2])
                        shelfCenter(shelfAngle[0]);
                    translate([shelfDepth(shelfAngle[0]) + endStockWidth / 4,
                               0])
                        rotate([90, 0, 0])
                        text(str("(",shelfAngle[1],")"),
                             halign="left",
                             size=endStockWidth * 0.65);
                }

                sizeLabel(shelfDepth(shelfAngle[0]));
            }
        }
    }
    for (i = [0 : len(uniqueShelfAngles())-1]) {
        shelfAngle = uniqueShelfAngles()[i];
        translate([combinedWidthOf(i-1), 0, 0]) {
            thirdAngle(endSize, rightLabels=undef) {
                union() {
                    shelfSupport(shelfAngle[0]);
                    translate([shelfDepth(shelfAngle[0]) + endStockWidth / 4,
                               0])
                        rotate([90, 0, 0])
                        text(str("(",shelfAngle[1] * 2,")"),
                             halign="left",
                             size=endStockWidth * 0.65);
                }

                union() {
                    sizeLabel(shelfDepth(shelfAngle[0]));

                    if (shelfAngle[0] > 0)
                        translate([0, 0, endStockWidth])
                            angleLabel(shelfAngle[0], -90, endStockWidth*1.25);

                    sp = [ for (x = slatPositions(shelfAngle[0])) x ];
                    translate([0, 0, endStockWidth]) {
                        for (x = [0 : ceil(len(sp) / 2)-1]) {
                            if (x > 0 ||
                                shelfAngle[0] < raisedFrontSlatMinAngle)
                                translate([sp[x], 0, 0])
                                    color("white") sizeLabel(slatStockWidth);

                            if (x > 0)
                                translate([0, 0, sizeLabelHeight() * (x - 1)])
                                    sizeLabel(sp[x], over=true);
                        }
                    }
                }
            }
        }
    }
}

for (i = [0 : len(uniqueShelfAngles())-1]) {
    shelfAngle = uniqueShelfAngles()[i];
    translate([combinedWidthOf(i-1) + shelfDepth(shelfAngle[0]) / 2,
               0,
               -sizeLabelHeight()])
        rotate([90, 0, 0])
        text(str(shelfAngle[0], "º"),
             halign="center",
             valign="top",
             size=endStockWidth);
 }

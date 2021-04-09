// Just the key
//cmdline: --projection=o --imgsize=2048,1024
include <../common/echo-camera-arg.scad>

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 24.65, -400.00, 36.97 ];
$vpf=22.50;
$vpd=206.02;

module endPieceKey(length)
    thirdAngle([length, endStockThickness, endStockWidth],
               topLabels=[0,1,1]) {
        children();

        sizeLabel(length);

        taRightSide(length) {
            translate([endStockThickness, 0])
                sizeLabel(endStockWidth, rotation=-90);
            sizeLabel(endStockThickness);
        }

        taTopSide(endStockWidth) {
            translate([length, 0, 0])
                sizeLabel(endStockThickness / 2, rotation=-90);
            translate([length - endStockWidth, 0, 0])
                sizeLabel(endStockWidth);
        }
    }
function endPieceKeySize(length) =
    thirdAngleSize([length, endStockThickness, endStockWidth],
                   topLabels=[0,1,1]);

module shelfSupportOrCenterKey(shelfAngle, height, thickness) {
    cutAngle = shelfCutAngle(shelfAngle);
    depth = shelfDepth(shelfAngle);

    cutDistance = height * tan(cutAngle);

    thirdAngle([depth, thickness, height],
               frontLabels=[1,0,1],
               topLabels=(cutAngle == 0 ? undef : [1,0,0])) {
        children();

        union() {
            translate([cutDistance, 0]) sizeLabel(depth - cutDistance*2);

            sp = [ for (x = slatPositions(shelfAngle)) x ];
            for (x = [1:len(sp)-1]) {
                translate([sp[x-1], 0, height])
                    sizeLabel(sp[x]-sp[x-1], over=true);
            }

            translate([sp[len(sp)-1], 0, height])
                sizeLabel(slatStockWidth, over=true);
            if (cutAngle > 0)
                translate([0, 0, height]) angleLabel(cutAngle, -90, height);
        }

        taRightSide(depth) {
            sizeLabel(thickness);
            translate([thickness, 0]) sizeLabel(height, rotation=-90);
        }

        // This generates a fourth child, even if cutAngle == 0, which
        // is why topLabels must be set to undef in the module
        // parameters.
        if (cutAngle != 0)
            translate([0, thickness, height])
                rotate([-90, 0, 0])
                sizeLabel(depth, over=true);
    }
}

function shelfSupportOrCenterKeySize(shelfAngle, height, thickness) =
    thirdAngleSize([shelfDepth(shelfAngle), thickness, height],
                   frontLabels=[1,0,1],
                   topLabels=[1,0,0]);

module shelfSupportKey(shelfAngle)
     shelfSupportOrCenterKey(shelfAngle, endStockWidth, endStockThickness)
     shelfSupport(shelfAngle);
function shelfSupportKeySize(shelfAngle) =
    shelfSupportOrCenterKeySize(shelfAngle, endStockWidth, endStockThickness);

module shelfCenterKey(shelfAngle)
     shelfSupportOrCenterKey(shelfAngle, slatStockThickness, slatStockWidth)
     translate([0, 0, slatStockThickness])
     shelfCenter(shelfAngle);
function shelfCenterKeySize(shelfAngle) =
    shelfSupportOrCenterKeySize(shelfAngle, slatStockThickness, slatStockWidth);

module slatKey()
    thirdAngle([slatLength(), slatStockWidth, slatStockThickness]) {
    slat();

    sizeLabel(slatLength());

    taRightSide(slatLength()) {
        sizeLabel(slatStockWidth);
        translate([slatStockWidth, 0])
            sizeLabel(slatStockThickness, rotation=-90);
    }
}
function slatKeySize() =
    thirdAngleSize([slatLength(), slatStockWidth, slatStockThickness],
                   topLabels=undef);

// KEY
module partsKey() {
    module labeledShelfPiece(i, height, thickness) {
        function distanceTo(i) =
            i == 0 ? 0 :
            shelfSupportOrCenterKeySize(uniqueShelfAngles()[i-1][0],
                                        height,
                                        thickness).x
            + endStockWidth * 1.5 + distanceTo(i-1);
        translate([distanceTo(i),  0, 0]) {
            children();
            translate([shelfSupportOrCenterKeySize(uniqueShelfAngles()[i][0],
                                                   height,
                                                   thickness).x+1,
                       0,
                       height / 2 + sizeLabelHeight()])
                rotate([90, 0, 0])
                text(str("(", uniqueShelfAngles()[i][1]*2, ")"),
                     size=endStockWidth / 2,
                     valign="center");
        }
    }

    key([keyChildInfo("END FRONT/BACK", 4, endPieceKeySize(endDepth)),
         keyChildInfo("END TOP/BOTTOM", 4, endPieceKeySize(endHeight)),
         keyChildInfo("SHELF SLAT", totalSlats(), slatKeySize()),
         keyChildInfo("SHELF SUPPORT",
                      len(shelfHeightsAndAngles) * 2,
                      shelfSupportKeySize(0)),
         keyChildInfo("SHELF CENTER",
                      len(shelfHeightsAndAngles) * 2,
                      shelfCenterKeySize(0))]) {
        endPieceKey(endDepth) endTopBottom();
        endPieceKey(endHeight) endFrontBack();
        slatKey();
        for (i=[0:len(uniqueShelfAngles())-1])
            labeledShelfPiece(i, endStockWidth, endStockThickness)
                shelfSupportKey(uniqueShelfAngles()[i][0]);
        for (i=[0:len(uniqueShelfAngles())-1])
            labeledShelfPiece(i, slatStockThickness, slatStockWidth)
                translate([0, 0, slatStockThickness])
                shelfCenterKey(uniqueShelfAngles()[i][0]);
    }
}

partsKey();

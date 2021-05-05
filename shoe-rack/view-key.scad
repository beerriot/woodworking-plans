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
    third_angle([length, endStockThickness, endStockWidth],
                top_labels=[0,1,1]) {
        children();

        size_label(length);

        ta_right_side(length) {
            translate([endStockThickness, 0])
                size_label(endStockWidth, rotation=-90);
            size_label(endStockThickness);
        }

        ta_top_side(endStockWidth) {
            translate([length, 0, 0])
                size_label(endStockThickness / 2, rotation=-90);
            translate([length - endStockWidth, 0, 0])
                size_label(endStockWidth);
        }
    }
function endPieceKeySize(length) =
    third_angle_size([length, endStockThickness, endStockWidth],
                     top_labels=[0,1,1]);

module shelfSupportOrCenterKey(shelfAngle, height, thickness) {
    cutAngle = shelfCutAngle(shelfAngle);
    depth = shelfDepth(shelfAngle);

    cutDistance = height * tan(cutAngle);

    third_angle([depth, thickness, height],
                front_labels=[1,0,1],
                top_labels=(cutAngle == 0 ? undef : [1,0,0])) {
        children();

        union() {
            translate([cutDistance, 0]) size_label(depth - cutDistance*2);

            sp = [ for (x = slatPositions(shelfAngle)) x ];
            for (x = [1:len(sp)-1]) {
                translate([sp[x-1], 0, height])
                    size_label(sp[x]-sp[x-1], over=true);
            }

            translate([sp[len(sp)-1], 0, height])
                size_label(slatStockWidth, over=true);
            if (cutAngle > 0)
                translate([0, 0, height]) angle_label(cutAngle, -90, height);
        }

        ta_right_side(depth) {
            size_label(thickness);
            translate([thickness, 0]) size_label(height, rotation=-90);
        }

        // This generates a fourth child, even if cutAngle == 0, which
        // is why top_labels must be set to undef in the module
        // parameters.
        if (cutAngle != 0)
            translate([0, thickness, height])
                rotate([-90, 0, 0])
                size_label(depth, over=true);
    }
}

function shelfSupportOrCenterKeySize(shelfAngle, height, thickness) =
    third_angle_size([shelfDepth(shelfAngle), thickness, height],
                     front_labels=[1,0,1],
                     top_labels=[1,0,0]);

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
    third_angle([slatLength(), slatStockWidth, slatStockThickness]) {
    slat();

    size_label(slatLength());

    ta_right_side(slatLength()) {
        size_label(slatStockWidth);
        translate([slatStockWidth, 0])
            size_label(slatStockThickness, rotation=-90);
    }
}
function slatKeySize() =
    third_angle_size([slatLength(), slatStockWidth, slatStockThickness],
                     top_labels=undef);

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
                       height / 2 + size_label_height()])
                rotate([90, 0, 0])
                text(str("(", uniqueShelfAngles()[i][1]*2, ")"),
                     size=endStockWidth / 2,
                     valign="center");
        }
    }

    key([["END FRONT/BACK", 4, endPieceKeySize(endDepth)],
         ["END TOP/BOTTOM", 4, endPieceKeySize(endHeight)],
         ["SHELF SLAT", totalSlats(), slatKeySize()],
         ["SHELF SUPPORT",
          len(shelfHeightsAndAngles) * 2,
          shelfSupportKeySize(0)],
         ["SHELF CENTER",
          len(shelfHeightsAndAngles) * 2,
          shelfCenterKeySize(0)]]) {
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
